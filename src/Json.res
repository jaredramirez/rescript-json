module J = Js.Json
module B = Belt

type value = J.t

let fromString: string => option<value> = s =>
  try J.parseExn(s)->Some catch {
  | _ => None
  }

let toString: value => string = J.stringify

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

module Decoder = {
  type rec error =
    | Failure(string, value)
    | Index(int, error)
    | Field(string, error)
    | OneOf(array<error>)

  @unboxed
  type t<'a> = Decoder(value => result<'a, error>)

  // primatives

  let string: t<string> = Decoder(
    j => j->J.decodeString->Utils.optToRes(Failure("invalid string", j)),
  )

  let bool: t<bool> = Decoder(j => j->J.decodeBoolean->Utils.optToRes(Failure("invalid bool", j)))

  let int: t<int> = Decoder(
    j => j->J.decodeNumber->B.Option.map(B.Float.toInt)->Utils.optToRes(Failure("invalid int", j)),
  )

  let float: t<float> = Decoder(j => j->J.decodeNumber->Utils.optToRes(Failure("invalid float", j)))

  // data structures

  let array: t<'a> => t<array<'a>> = (Decoder(aDecoder)) => Decoder(
    j =>
      j
      ->J.decodeArray
      ->Utils.optToRes(Failure("invalid array", j))
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
      ->Utils.optToRes(Failure("invalid object", j))
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
      ->Utils.optToRes(Failure("invalid object", j))
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

  let field: (string, t<'a>) => t<'a> = (key, Decoder(aDecoder)) => Decoder(
    j =>
      j
      ->J.decodeObject
      ->Utils.optToRes(Failure("invalid object", j))
      ->B.Result.flatMap(obj =>
        obj->Js.Dict.get(key)->Utils.optToRes(Field(key, Failure("does not exist", j)))
      )
      ->B.Result.flatMap(jv => aDecoder(jv)->Utils.resMapError(e => Field(key, e))),
  )

  let at: (string, array<string>, t<'a>) => t<'a> = (firstKey, keys, Decoder(aDecoder)) => Decoder(
    j => {
      keys->Js.Array2.reduce((acc, cur) => {
        switch acc {
        | Error(_) => acc
        | Ok(sj, _) =>
          sj
          ->J.decodeObject
          ->Utils.optToRes(Failure("invalid object", sj))
          ->B.Result.flatMap(sObj =>
            sObj
            ->Js.Dict.get(cur)
            ->Utils.optToRes(Field(cur, Failure("does not exist", sj)))
            ->B.Result.map(ssj => (ssj, cur))
          )
        }
      }, Ok(
        j,
        firstKey,
      ))->B.Result.flatMap(((jv, key)) => aDecoder(jv)->Utils.resMapError(e => Field(key, e)))
    },
  )

  let index: (int, t<'a>) => t<'a> = (index, Decoder(aDecoder)) => Decoder(
    j =>
      j
      ->J.decodeArray
      ->Utils.optToRes(Failure("invalid array", j))
      ->B.Result.flatMap(arr =>
        arr->B.Array.get(index)->Utils.optToRes(Index(index, Failure("out of bounds", j)))
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
          | Error(es) =>
            switch cur(j) {
            | Error(ne) => Error(list{ne, ...es})
            | Ok(a) => Ok(a)
            }

          | Ok(_) => acc
          }
        }, Error(list{e}))->Utils.resMapError(es => es->B.List.toArray->OneOf)
      },
  )

  // run decoders

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
}
