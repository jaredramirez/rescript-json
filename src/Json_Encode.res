module J = Js.Json
module B = Belt

type value = J.t

@val @scope("JSON")
external stringify: (value, Js.Nullable.t<'a>, int) => string = "stringify"

let encode: (value, int) => string = (v, i) => stringify(v, Js.Nullable.null, i)

// primative

let string: string => value = J.string

let int: int => value = i => i->B.Float.fromInt->J.number

let float: float => value = J.number

let bool: bool => value = J.boolean

let null: value = J.null

// data structures

let array: (array<'i>, 'i => value) => value = (arr, encodeI) =>
  arr->Js.Array2.map(encodeI)->J.array

let list: (list<'i>, 'i => value) => value = (l, encodeI) =>
  l->B.List.toArray->Js.Array2.map(encodeI)->J.array

let object: array<(string, value)> => value = arr => arr->Js.Dict.fromArray->J.object_

let dict: Js.Dict.t<value> => value = obj => obj->J.object_
