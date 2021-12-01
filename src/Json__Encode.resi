@@ocaml.text("")
type value = Js.Json.t

@@ocaml.text("")
let encode: (value, int) => string

// primative

@@ocaml.text("")
let string: string => value

@@ocaml.text("")
let int: int => value

@@ocaml.text("")
let float: float => value

@@ocaml.text("")
let bool: bool => value

@@ocaml.text("")
let null: value

// data structures

@@ocaml.text("")
let array: (array<'i>, 'i => value) => value

@@ocaml.text("")
let list: (list<'i>, 'i => value) => value 

@@ocaml.text("")
let object: array<(string, value)> => value 

@@ocaml.text("")
let dict: Js.Dict.t<value> => value
