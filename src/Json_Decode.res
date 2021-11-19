module J = Js.Json
module B = Belt

module Utils = {
  let optToRes = (option, err) =>
    switch option {
    | None => Error(err)
    | Some(a) => Ok(a)
    }

  let resMapError = (res, f) =>
    switch res {
    | Ok(v) => Ok(v)
    | Error(e) => Error(f(e))
    }
}

type value = J.t

type rec error =
  | Failure(string, value)
  | Index(int, error)
  | Field(string, error)
  | OneOf(error, array<error>)

@unboxed
type t<'a> = Decoder(value => result<'a, error>)

// primatives

let string: t<string> = Decoder(j => j->J.decodeString->Utils.optToRes(Failure("a STRING", j)))

let bool: t<bool> = Decoder(j => j->J.decodeBoolean->Utils.optToRes(Failure("a BOOL", j)))

let int: t<int> = Decoder(
  j => j->J.decodeNumber->B.Option.map(B.Float.toInt)->Utils.optToRes(Failure("an INT", j)),
)

let float: t<float> = Decoder(j => j->J.decodeNumber->Utils.optToRes(Failure("a FLOAT", j)))

// data structures

let array: t<'a> => t<array<'a>> = (Decoder(aDecoder)) => Decoder(
  j =>
    j
    ->J.decodeArray
    ->Utils.optToRes(Failure("an ARRAY", j))
    ->B.Result.flatMap(arr => arr->Js.Array2.reducei((acc, cur, index) => {
        switch acc {
        | Error(_) => acc
        | Ok(soFar) =>
          switch aDecoder(cur) {
          | Error(error) => Error(Index(index, error))
          | Ok(a) => soFar->Js.Array2.concat([a])->Ok
          }
        }
      }, Ok([]))),
)

let dict: t<'a> => t<Js.Dict.t<'a>> = (Decoder(aDecoder)) => Decoder(
  j =>
    j
    ->J.decodeObject
    ->Utils.optToRes(Failure("an OBJECT", j))
    ->B.Result.flatMap(obj => obj->Js.Dict.entries->Js.Array2.reduce((acc, (key, cur)) => {
        switch acc {
        | Error(_) => acc
        | Ok(soFar) =>
          switch aDecoder(cur) {
          | Error(error) => Error(Field(key, error))
          | Ok(a) => soFar->Js.Array2.concat([(key, a)])->Ok
          }
        }
      }, Ok([])))
    ->B.Result.map(Js.Dict.fromArray),
)

let keyValuePairs: t<'a> => t<array<(string, 'a)>> = (Decoder(aDecoder)) => Decoder(
  j =>
    j
    ->J.decodeObject
    ->Utils.optToRes(Failure("an OBJECT", j))
    ->B.Result.flatMap(obj => obj->Js.Dict.entries->Js.Array2.reduce((acc, (key, cur)) => {
        switch acc {
        | Error(_) => acc
        | Ok(soFar) =>
          switch aDecoder(cur) {
          | Error(error) => Error(Field(key, error))
          | Ok(a) => soFar->Js.Array2.concat([(key, a)])->Ok
          }
        }
      }, Ok([]))),
)

// object primatives

let fieldHelp = (j, key) =>
  j
  ->J.decodeObject
  ->Utils.optToRes(Failure(`an OBJECT with a field named '${key}'`, j))
  ->B.Result.flatMap(sObj =>
    sObj->Js.Dict.get(key)->Utils.optToRes(Failure(`an OBJECT with a field named '${key}'`, j))
  )

let field: (string, t<'a>) => t<'a> = (key, Decoder(aDecoder)) => Decoder(
  j =>
    j->fieldHelp(key)->B.Result.flatMap(jv => aDecoder(jv)->Utils.resMapError(e => Field(key, e))),
)

let at: (string, array<string>, t<'a>) => t<'a> = (firstKey, keys, Decoder(aDecoder)) => Decoder(
  j => {
    keys->Js.Array2.reduce((acc, cur) => {
      switch acc {
      | Error(_) => acc
      | Ok(sj, _) => fieldHelp(sj, cur)->B.Result.map(ssj => (ssj, cur))
      }
    }, fieldHelp(j, firstKey)->B.Result.map(ssj => (
      ssj,
      firstKey,
    )))->B.Result.flatMap(((jv, key)) => aDecoder(jv)->Utils.resMapError(e => Field(key, e)))
  },
)

let index: (int, t<'a>) => t<'a> = (index, Decoder(aDecoder)) => Decoder(
  j =>
    j
    ->J.decodeArray
    ->Utils.optToRes(Failure("an ARRAY", j))
    ->B.Result.flatMap(arr =>
      if B.Array.length(arr) == 0 {
        Error(
          Failure(
            `a NON-EMPTY array. Need index ${index->B.Int.toString} but only saw an empty array`,
            j,
          ),
        )
      } else {
        arr
        ->B.Array.get(index)
        ->Utils.optToRes(
          if index >= B.Array.length(arr) {
            Failure(
              `a LONGER array. Need index ${index->B.Int.toString} but only saw ${arr
                ->B.Array.length
                ->B.Int.toString} entries`,
              j,
            )
          } else {
            Failure(
              `a POSITIVE index. Array has ${arr
                ->B.Array.length
                ->B.Int.toString} entries but tried to decode index ${index->B.Int.toString}`,
              j,
            )
          },
        )
      }
    )
    ->B.Result.flatMap(jv => aDecoder(jv)->Utils.resMapError(e => Index(index, e))),
)

// inconsistent structure

let option: t<'a> => t<option<'a>> = (Decoder(aDecoder)) => Decoder(
  j => j->aDecoder->B.Result.map(a => Some(a))->B.Result.getWithDefault(None)->Ok,
)

let oneOf: (t<'a>, array<t<'a>>) => t<'a> = (Decoder(firstDecoder), decoders) => Decoder(
  j =>
    switch firstDecoder(j) {
    | Ok(a) => Ok(a)
    | Error(e) => decoders->Js.Array2.reduce((acc, Decoder(cur)) => {
        switch acc {
        | Error((ef, es)) =>
          switch cur(j) {
          | Error(ne) => Error((ef, list{ne, ...es}))
          | Ok(a) => Ok(a)
          }

        | Ok(_) => acc
        }
      }, Error((e, list{})))->Utils.resMapError(((ef, es)) => OneOf(ef, es->B.List.toArray))
    },
)

// run decoders

let fromString: string => option<value> = s =>
  try J.parseExn(s)->Some catch {
  | _ => None
  }

let decodeString: (t<'a>, string) => result<'a, error> = (Decoder(decoder), s) =>
  s->fromString->Utils.optToRes(Failure("Invalid JSON", J.string(s)))->B.Result.flatMap(decoder)

let decodeValue: (t<'a>, value) => result<'a, error> = (Decoder(decoder), j) => decoder(j)

let errorToString: error => string = _e => "TODO"

// combine

let map: (t<'a>, 'a => 'b) => t<'b> = (Decoder(decoder), f) => Decoder(
  j => j->decoder->B.Result.map(f),
)

let map2: (t<'a>, t<'b>, ('a, 'b) => 'c) => t<'c> = (
  Decoder(decoderA),
  Decoder(decoderB),
  f,
) => Decoder(j => j->decoderA->B.Result.flatMap(a => j->decoderB->B.Result.map(b => f(a, b))))

let andMap: (t<'a => 'b>, t<'a>) => t<'b> = (decoderF, decoderA) =>
  map2(decoderF, decoderA, (f, a) => f(a))

// fancy

let null: 'a => t<'a> = v => Decoder(
  j => j->J.decodeNull->Utils.optToRes(Failure("invalid null", j))->B.Result.map(_ => v),
)

let nullable: t<'a> => t<option<'a>> = decoder => oneOf(decoder->map(a => Some(a)), [null(None)])

let value: t<value> = Decoder(j => Ok(j))

let andThen: (t<'a>, 'a => t<'b>) => t<'b> = (Decoder(decoder), f) => Decoder(
  j =>
    j
    ->decoder
    ->B.Result.flatMap(a => {
      let Decoder(b) = f(a)
      b(j)
    }),
)

let succeed: 'a => t<'a> = a => Decoder(_ => Ok(a))

let fail: string => t<'a> = err => Decoder(j => Error(Failure(err, j)))

// combine extra

let map3: (t<'a>, t<'b>, t<'c>, ('a, 'b, 'c) => 'val) => t<'val> = (
  decoderA,
  decoderB,
  decoderC,
  f,
) => succeed(f)->andMap(decoderA)->andMap(decoderB)->andMap(decoderC)

let map4: (t<'a>, t<'b>, t<'c>, t<'d>, ('a, 'b, 'c, 'd) => 'val) => t<'val> = (
  decoderA,
  decoderB,
  decoderC,
  decoderD,
  f,
) => succeed(f)->andMap(decoderA)->andMap(decoderB)->andMap(decoderC)->andMap(decoderD)

let map5: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, ('a, 'b, 'c, 'd, 'e) => 'val) => t<'val> = (
  decoderA,
  decoderB,
  decoderC,
  decoderD,
  decoderE,
  f,
) =>
  succeed(f)
  ->andMap(decoderA)
  ->andMap(decoderB)
  ->andMap(decoderC)
  ->andMap(decoderD)
  ->andMap(decoderE)

let map6: (
  t<'a>,
  t<'b>,
  t<'c>,
  t<'d>,
  t<'e>,
  t<'f>,
  ('a, 'b, 'c, 'd, 'e, 'f) => 'val,
) => t<'val> = (decoderA, decoderB, decoderC, decoderD, decoderE, decoderF, f) =>
  succeed(f)
  ->andMap(decoderA)
  ->andMap(decoderB)
  ->andMap(decoderC)
  ->andMap(decoderD)
  ->andMap(decoderE)
  ->andMap(decoderF)

let map7: (
  t<'a>,
  t<'b>,
  t<'c>,
  t<'d>,
  t<'e>,
  t<'f>,
  t<'g>,
  ('a, 'b, 'c, 'd, 'e, 'f, 'g) => 'val,
) => t<'val> = (decoderA, decoderB, decoderC, decoderD, decoderE, decoderF, decoderG, f) =>
  succeed(f)
  ->andMap(decoderA)
  ->andMap(decoderB)
  ->andMap(decoderC)
  ->andMap(decoderD)
  ->andMap(decoderE)
  ->andMap(decoderF)
  ->andMap(decoderG)

let map8: (
  t<'a>,
  t<'b>,
  t<'c>,
  t<'d>,
  t<'e>,
  t<'f>,
  t<'g>,
  t<'h>,
  ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h) => 'val,
) => t<'val> = (
  decoderA,
  decoderB,
  decoderC,
  decoderD,
  decoderE,
  decoderF,
  decoderG,
  decoderH,
  f,
) =>
  succeed(f)
  ->andMap(decoderA)
  ->andMap(decoderB)
  ->andMap(decoderC)
  ->andMap(decoderD)
  ->andMap(decoderE)
  ->andMap(decoderF)
  ->andMap(decoderG)
  ->andMap(decoderH)
