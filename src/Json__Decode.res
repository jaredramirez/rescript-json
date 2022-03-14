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

  let resAndMap = (resF, resV) => {
    resF->B.Result.flatMap(f => resV->B.Result.map(v => f(v)))
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

let string: t<string> = Decoder(
  j => j->J.decodeString->Utils.optToRes(Failure("Expecting a STRING", j)),
)

let bool: t<bool> = Decoder(j => j->J.decodeBoolean->Utils.optToRes(Failure("Expecting a BOOL", j)))

let int: t<int> = Decoder(
  j =>
    j->J.decodeNumber->B.Option.map(B.Float.toInt)->Utils.optToRes(Failure("Expecting an INT", j)),
)

let float: t<float> = Decoder(
  j => j->J.decodeNumber->Utils.optToRes(Failure("Expecting a FLOAT", j)),
)

// data structures

let array: t<'a> => t<array<'a>> = (Decoder(aDecoder)) => Decoder(
  j =>
    j
    ->J.decodeArray
    ->Utils.optToRes(Failure("Expecting an ARRAY", j))
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

let list: t<'a> => t<list<'a>> = (Decoder(aDecoder)) => Decoder(
  j =>
    j
    ->J.decodeArray
    ->Utils.optToRes(Failure("Expecting an ARRAY", j))
    ->B.Result.flatMap(arr => arr->B.Array.reverse->Js.Array2.reducei((acc, cur, index) => {
        switch acc {
        | Error(_) => acc
        | Ok(soFar) =>
          switch aDecoder(cur) {
          | Error(error) => Error(Index(index, error))
          | Ok(a) => list{a, ...soFar}->Ok
          }
        }
      }, Ok(list{}))),
)

let dict: t<'a> => t<Js.Dict.t<'a>> = (Decoder(aDecoder)) => Decoder(
  j =>
    j
    ->J.decodeObject
    ->Utils.optToRes(Failure("Expecting an OBJECT", j))
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
    ->Utils.optToRes(Failure("Expecting an OBJECT", j))
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

let tuple2: (t<'a>, t<'b>) => t<('a, 'b)> = (Decoder(aDecoder), Decoder(bDecoder)) => Decoder(
  j =>
    j
    ->J.decodeArray
    ->Utils.optToRes(Failure("Expecting an ARRAY", j))
    ->B.Result.flatMap(arr =>
      switch arr {
      | [a, b] => Ok((a, b) => (a, b))->Utils.resAndMap(aDecoder(a))->Utils.resAndMap(bDecoder(b))
      | _ => Error(Failure("Expecting an ARRAY with 2 elements", j))
      }
    ),
)

let tuple3: (t<'a>, t<'b>, t<'c>) => t<('a, 'b, 'c)> = (
  Decoder(aDecoder),
  Decoder(bDecoder),
  Decoder(cDecoder),
) => Decoder(
  j =>
    j
    ->J.decodeArray
    ->Utils.optToRes(Failure("Expecting an ARRAY", j))
    ->B.Result.flatMap(arr =>
      switch arr {
      | [a, b, c] =>
        Ok((a, b, c) => (a, b, c))
        ->Utils.resAndMap(aDecoder(a))
        ->Utils.resAndMap(bDecoder(b))
        ->Utils.resAndMap(cDecoder(c))

      | _ => Error(Failure("Expecting an ARRAY with 3 elements", j))
      }
    ),
)

let tuple4: (t<'a>, t<'b>, t<'c>, t<'d>) => t<('a, 'b, 'c, 'd)> = (
  Decoder(aDecoder),
  Decoder(bDecoder),
  Decoder(cDecoder),
  Decoder(dDecoder),
) => Decoder(
  j =>
    j
    ->J.decodeArray
    ->Utils.optToRes(Failure("Expecting an ARRAY", j))
    ->B.Result.flatMap(arr =>
      switch arr {
      | [a, b, c, d] =>
        Ok((a, b, c, d) => (a, b, c, d))
        ->Utils.resAndMap(aDecoder(a))
        ->Utils.resAndMap(bDecoder(b))
        ->Utils.resAndMap(cDecoder(c))
        ->Utils.resAndMap(dDecoder(d))

      | _ => Error(Failure("Expecting an ARRAY with 4 elements", j))
      }
    ),
)

let tuple5: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>) => t<('a, 'b, 'c, 'd, 'e)> = (
  Decoder(aDecoder),
  Decoder(bDecoder),
  Decoder(cDecoder),
  Decoder(dDecoder),
  Decoder(eDecoder),
) => Decoder(
  j =>
    j
    ->J.decodeArray
    ->Utils.optToRes(Failure("Expecting an ARRAY", j))
    ->B.Result.flatMap(arr =>
      switch arr {
      | [a, b, c, d, e] =>
        Ok((a, b, c, d, e) => (a, b, c, d, e))
        ->Utils.resAndMap(aDecoder(a))
        ->Utils.resAndMap(bDecoder(b))
        ->Utils.resAndMap(cDecoder(c))
        ->Utils.resAndMap(dDecoder(d))
        ->Utils.resAndMap(eDecoder(e))
      | _ => Error(Failure("Expecting an ARRAY with 5 elements", j))
      }
    ),
)

let tuple6: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, t<'f>) => t<('a, 'b, 'c, 'd, 'e, 'f)> = (
  Decoder(aDecoder),
  Decoder(bDecoder),
  Decoder(cDecoder),
  Decoder(dDecoder),
  Decoder(eDecoder),
  Decoder(fDecoder),
) => Decoder(
  j =>
    j
    ->J.decodeArray
    ->Utils.optToRes(Failure("Expecting an ARRAY", j))
    ->B.Result.flatMap(arr =>
      switch arr {
      | [a, b, c, d, e, f] =>
        Ok((a, b, c, d, e, f) => (a, b, c, d, e, f))
        ->Utils.resAndMap(aDecoder(a))
        ->Utils.resAndMap(bDecoder(b))
        ->Utils.resAndMap(cDecoder(c))
        ->Utils.resAndMap(dDecoder(d))
        ->Utils.resAndMap(eDecoder(e))
        ->Utils.resAndMap(fDecoder(f))
      | _ => Error(Failure("Expecting an ARRAY with 6 elements", j))
      }
    ),
)

let tuple7: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, t<'f>, t<'g>) => t<('a, 'b, 'c, 'd, 'e, 'f, 'g)> = (
  Decoder(aDecoder),
  Decoder(bDecoder),
  Decoder(cDecoder),
  Decoder(dDecoder),
  Decoder(eDecoder),
  Decoder(fDecoder),
  Decoder(gDecoder),
) => Decoder(
  j =>
    j
    ->J.decodeArray
    ->Utils.optToRes(Failure("Expecting an ARRAY", j))
    ->B.Result.flatMap(arr =>
      switch arr {
      | [a, b, c, d, e, f, g] =>
        Ok((a, b, c, d, e, f, g) => (a, b, c, d, e, f, g))
        ->Utils.resAndMap(aDecoder(a))
        ->Utils.resAndMap(bDecoder(b))
        ->Utils.resAndMap(cDecoder(c))
        ->Utils.resAndMap(dDecoder(d))
        ->Utils.resAndMap(eDecoder(e))
        ->Utils.resAndMap(fDecoder(f))
        ->Utils.resAndMap(gDecoder(g))
      | _ => Error(Failure("Expecting an ARRAY with 7 elements", j))
      }
    ),
)

let tuple8: (
  t<'a>,
  t<'b>,
  t<'c>,
  t<'d>,
  t<'e>,
  t<'f>,
  t<'g>,
  t<'h>,
) => t<('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h)> = (
  Decoder(aDecoder),
  Decoder(bDecoder),
  Decoder(cDecoder),
  Decoder(dDecoder),
  Decoder(eDecoder),
  Decoder(fDecoder),
  Decoder(gDecoder),
  Decoder(hDecoder),
) => Decoder(
  j =>
    j
    ->J.decodeArray
    ->Utils.optToRes(Failure("Expecting an ARRAY", j))
    ->B.Result.flatMap(arr =>
      switch arr {
      | [a, b, c, d, e, f, g, h] =>
        Ok((a, b, c, d, e, f, g, h) => (a, b, c, d, e, f, g, h))
        ->Utils.resAndMap(aDecoder(a))
        ->Utils.resAndMap(bDecoder(b))
        ->Utils.resAndMap(cDecoder(c))
        ->Utils.resAndMap(dDecoder(d))
        ->Utils.resAndMap(eDecoder(e))
        ->Utils.resAndMap(fDecoder(f))
        ->Utils.resAndMap(gDecoder(g))
        ->Utils.resAndMap(hDecoder(h))
      | _ => Error(Failure("Expecting an ARRAY with 8 elements", j))
      }
    ),
)

// object primatives

let rec field: (string, t<'a>) => t<'a> = (key, Decoder(aDecoder)) => Decoder(
  j =>
    j->fieldHelp(key)->B.Result.flatMap(jv => aDecoder(jv)->Utils.resMapError(e => Field(key, e))),
)
and fieldHelp = (j, key) =>
  j
  ->J.decodeObject
  ->Utils.optToRes(Failure(`Expecting an OBJECT with a field named '${key}'`, j))
  ->B.Result.flatMap(sObj =>
    sObj
    ->Js.Dict.get(key)
    ->Utils.optToRes(Failure(`Expecting an OBJECT with a field named '${key}'`, j))
  )

let rec at: (string, array<string>, t<'a>) => t<'a> = (firstKey, keys, decoder) =>
  atHelp(firstKey, Belt.List.fromArray(keys), decoder)
and atHelp: (string, list<string>, t<'a>) => t<'a> = (firstKey, keys, decoder) => {
  field(
    firstKey,
    switch keys {
    | list{} => decoder
    | list{nextKey, ...restKeys} => atHelp(nextKey, restKeys, decoder)
    },
  )
}

let index: (int, t<'a>) => t<'a> = (index, Decoder(aDecoder)) => Decoder(
  j =>
    j
    ->J.decodeArray
    ->Utils.optToRes(Failure("Expecting an ARRAY", j))
    ->B.Result.flatMap(arr =>
      if B.Array.length(arr) == 0 {
        Error(
          Failure(
            `Expecting a NON-EMPTY array. Need index ${index->B.Int.toString} but only saw an empty array`,
            j,
          ),
        )
      } else {
        arr
        ->B.Array.get(index)
        ->Utils.optToRes(
          if index >= B.Array.length(arr) {
            Failure(
              `Expecting a LONGER array. Need index ${index->B.Int.toString} but only saw ${arr
                ->B.Array.length
                ->B.Int.toString} entries`,
              j,
            )
          } else {
            Failure(`Expecting a POSITIVE index but saw ${index->B.Int.toString}`, j)
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

let decodeString: (string, t<'a>) => result<'a, error> = (s, Decoder(decoder)) =>
  s->fromString->Utils.optToRes(Failure("Invalid JSON", J.string(s)))->B.Result.flatMap(decoder)

let decodeValue: (value, t<'a>) => result<'a, error> = (j, Decoder(decoder)) => decoder(j)

// print errors

let joinList = (l, s) =>
  switch l {
  | list{} => ""
  | list{h, ...r} =>
    B.List.reduce(r, h, (acc, cur) => {
      acc ++ s ++ cur
    })
  }

let indent = str => joinList(str->Js.String2.split("\n")->B.List.fromArray, "\n    ")

let rec errorToStringHelp = (error, context) =>
  switch error {
  | Field(key, err) => {
      // TODO `.${key}` if key is a valid id
      let fieldName = `["${key}"]`
      errorToStringHelp(err, list{fieldName, ...context})
    }
  | Index(index, err) => {
      let fieldName = `[${index->B.Int.toString}]`
      errorToStringHelp(err, list{fieldName, ...context})
    }
  | OneOf(firstErr, errs) =>
    switch errs {
    | [] => errorToStringHelp(firstErr, context)
    | _ => {
        let starter = switch context->B.List.reverse {
        | list{} => "oneOf"
        | reveresed => `oneOf at json${reveresed->joinList("")}`
        }
        let intro = `${starter} failed in the following ${context
          ->B.List.length
          ->B.Int.toString} ways:`
        joinList(
          list{
            intro,
            ...B.Array.concat([firstErr], errs)
            ->B.List.fromArray
            ->B.List.mapWithIndex((i, err) =>
              "\n\n(" ++ B.Int.toString(i + 1) ++ ") " ++ indent(errorToStringHelp(err, list{}))
            ),
          },
          "\n\n",
        )
      }
    }
  | Failure(str, j) => {
      let intro = switch context->B.List.reverse {
      | list{} => "Problem with the given value:\n\n    "
      | reveresed => `Problem with the value at json${reveresed->joinList("")}:\n\n    `
      }
      `${intro}${indent(Json__Encode.encode(j, ~indentLevel=4))}\n\n${str}`
    }
  }

let errorToString: error => string = e => errorToStringHelp(e, list{})

// combine

let map: (t<'a>, ~f: 'a => 'b) => t<'b> = (Decoder(decoder), ~f) => Decoder(
  j => j->decoder->B.Result.map(f),
)

let map2: (t<'a>, t<'b>, ~f: ('a, 'b) => 'c) => t<'c> = (
  Decoder(decoderA),
  Decoder(decoderB),
  ~f,
) => Decoder(j => j->decoderA->B.Result.flatMap(a => j->decoderB->B.Result.map(b => f(a, b))))

let andMap: (t<'a => 'b>, t<'a>) => t<'b> = (decoderF, decoderA) =>
  map2(decoderF, decoderA, ~f=(f, a) => f(a))

// fancy

let null: 'a => t<'a> = v => Decoder(
  j => j->J.decodeNull->Utils.optToRes(Failure("invalid null", j))->B.Result.map(_ => v),
)

let nullable: t<'a> => t<option<'a>> = decoder => oneOf(decoder->map(~f=a => Some(a)), [null(None)])

let value: t<value> = Decoder(j => Ok(j))

let andThen: (t<'a>, ~f: 'a => t<'b>) => t<'b> = (Decoder(decoder), ~f) => Decoder(
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

let map3: (t<'a>, t<'b>, t<'c>, ~f: ('a, 'b, 'c) => 'val) => t<'val> = (
  decoderA,
  decoderB,
  decoderC,
  ~f,
) => succeed(f)->andMap(decoderA)->andMap(decoderB)->andMap(decoderC)

let map4: (t<'a>, t<'b>, t<'c>, t<'d>, ~f: ('a, 'b, 'c, 'd) => 'val) => t<'val> = (
  decoderA,
  decoderB,
  decoderC,
  decoderD,
  ~f,
) => succeed(f)->andMap(decoderA)->andMap(decoderB)->andMap(decoderC)->andMap(decoderD)

let map5: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, ~f: ('a, 'b, 'c, 'd, 'e) => 'val) => t<'val> = (
  decoderA,
  decoderB,
  decoderC,
  decoderD,
  decoderE,
  ~f,
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
  ~f: ('a, 'b, 'c, 'd, 'e, 'f) => 'val,
) => t<'val> = (decoderA, decoderB, decoderC, decoderD, decoderE, decoderF, ~f) =>
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
  ~f: ('a, 'b, 'c, 'd, 'e, 'f, 'g) => 'val,
) => t<'val> = (decoderA, decoderB, decoderC, decoderD, decoderE, decoderF, decoderG, ~f) =>
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
  ~f: ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h) => 'val,
) => t<'val> = (
  decoderA,
  decoderB,
  decoderC,
  decoderD,
  decoderE,
  decoderF,
  decoderG,
  decoderH,
  ~f,
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
