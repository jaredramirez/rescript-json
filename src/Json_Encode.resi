type value = Js.Json.t

let encode: (value, int) => string

// primative

let string: string => value

let int: int => value

let float: float => value

let bool: bool => value

let null: value

// data structures

let array: (array<'i>, 'i => value) => value

let list: (list<'i>, 'i => value) => value 

let object: array<(string, value)> => value 

let dict: Js.Dict.t<value> => value
