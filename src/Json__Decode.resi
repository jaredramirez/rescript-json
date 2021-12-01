@@ocaml.text("{1:header Turn JSON values into Rescript values}")

type t<'a>
@@ocaml.text("A value that knows how to decode JSON values.")

@@ocaml.text("{2:primatives Primatives}")

@@ocaml.text("{3:string string}")
let string: t<string> 
@@ocaml.text("
Decode a JSON string into a Rescript [string].

{[
  decodeString(string, \"true\")              == Error(...)
  decodeString(string, \"42\")                == Error(...)
  decodeString(string, \"3.14\")              == Error(...)
  decodeString(string, \"\\\"hello\\\"\")         == Ok(\"hello\")
  decodeString(string, \"{ \\\"hello\\\": 42 }\") == Error(...)
]}")

let bool: t<bool> 
@@ocaml.text("
Decode a JSON bool into a Rescript [bool].

{[
  decodeString(bool, \"true\")              == Ok(true)
  decodeString(bool, \"42\")                == Error(...)
  decodeString(bool, \"3.14\")              == Error(...)
  decodeString(bool, \"\\\"hello\\\"\")         == Error(...)
  decodeString(bool, \"{ \\\"hello\\\": 42 }\") == Error(...)
]}")

let int: t<int> 
@@ocaml.text("
Decode a JSON int into a Rescript [int].

{[
  decodeString(int, \"true\")              == Error(...)
  decodeString(int, \"42\")                == Ok(42)
  decodeString(int, \"3.14\")              == Error(...)
  decodeString(int, \"\\\"hello\\\"\")         == Error(...)
  decodeString(int, \"{ \\\"hello\\\": 42 }\") == Error(...)
]}")

let float: t<float> 
@@ocaml.text("
Decode a JSON float into a Rescript [float].

{[
  decodeString(float, \"true\")              == Error(...)
  decodeString(float, \"42\")                == Error(...)
  decodeString(float, \"3.14\")              == Ok(3.14)
  decodeString(float, \"\\\"hello\\\"\")         == Error(...)
  decodeString(float, \"{ \\\"hello\\\": 42 }\") == Error(...)
]}")

@@ocaml.text("{2:data-structures Data Structures}")

let nullable: t<'a> => t<option<'a>> 
@@ocaml.text("
Decode a nullable JSON value into a Rescript value.

{[
  decodeString(nullable(int), \"13\")   == Ok(Some(13))
  decodeString(nullable(int), \"42\")   == Ok(Some(42))
  decodeString(nullable(int), \"null\") == Ok(None)
  decodeString(nullable(int), \"true\") == Error(...)
]}")

let array: t<'a> => t<array<'a>> 
@@ocaml.text("
Decode a JSON value into a Rescript [array].

{[
  decodeString(array(int), \"[1,2,3]\")       == Ok([1, 2, 3])
  decodeString(array(bool), \"[true,false]\") == Ok([true, false])
]}")

let list: t<'a> => t<list<'a>>
@@ocaml.text("
Decode a JSON value into a Rescript [list].

{[
  decodeString(list(int), \"[1,2,3]\")       == Ok(list{1, 2, 3})
  decodeString(list(bool), \"[true,false]\") == Ok(list{true, false})
]}")

let dict: t<'a> => t<Js.Dict.t<'a>> 
@@ocaml.text("
Decode a JSON value into a Rescript [Js.Dict.t].

{[
  decodeString(dict(int), \"{ \\\"alice\\\": 42, \\\"bob\\\": 99 }\")
    == Ok(Js.Dict.fromArray([(\"alice\", 42), (\"bob\", 99)]))
]}")

let keyValuePairs: t<'a> => t<array<(string, 'a)>> 
@@ocaml.text("
Decode a JSON value into a Rescript [array] of pair.

{[
  decodeString(dict(int), \"{ \\\"alice\\\": 42, \\\"bob\\\": 99 }\")
    == Ok([(\"alice\", 42), (\"bob\", 99)])
]}")


@@ocaml.text("{3:tuples Tuples}

Decode a JSON value into a Rescript tuple with 2 through 8 elements. This is helpful if you're dealing with a heterogeneous JSON array, like [[1, \"hey\"]]. {b Modeling your JSON like this is generally a bad idea.} Unfortunatly, we often have to use JSON from places outside our control, hence these functions.

From [tuples4-8], the use looks just like the examples for [tuple2] and [tuple3]
")

@@ocaml.text("")
let tuple2: (t<'a>, t<'b>) => t<('a, 'b)>
@@ocaml.text("
Decode a JSON value into a Rescript tuple with 2 elements.

{[
  decodeString(tuple2(int, string), \"[1, \\\"hey\\\"]\") == Ok((1, \"hey\"))
]}")

@@ocaml.text("")
let tuple3: (t<'a>, t<'b>, t<'c>) => t<('a, 'b, 'c)>
@@ocaml.text("
Decode a JSON value into a Rescript tuple with 3 elements.

{[
  decodeString(tuple3(int, string, bool), \"[1, \\\"hey\\\", bool]\") == Ok((1, \"hey\", true))
]}")

@@ocaml.text("")
let tuple4: (t<'a>, t<'b>, t<'c>, t<'d>) => t<('a, 'b, 'c, 'd)>

@@ocaml.text("")
let tuple5: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>) => t<('a, 'b, 'c, 'd, 'e)>

@@ocaml.text("")
let tuple6: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, t<'f>) => t<('a, 'b, 'c, 'd, 'e, 'f)>

@@ocaml.text("")
let tuple7: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, t<'f>, t<'g>) => t<('a, 'b, 'c, 'd, 'e, 'f, 'g)>

@@ocaml.text("")
let tuple8: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, t<'f>, t<'g>, t<'h>) => t<('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h)>

@@ocaml.text("{2:obj-primatives Object Primatives}")

@@ocaml.text("")
let field: (string, t<'a>) => t<'a> 

@@ocaml.text("")
let at: (string, array<string>, t<'a>) => t<'a> 

@@ocaml.text("")
let index: (int, t<'a>) => t<'a> 

@@ocaml.text("{2:inconsisent-structur Inconsistent Structure}")

@@ocaml.text("")
let option: t<'a> => t<option<'a>> 

@@ocaml.text("")
let oneOf: (t<'a>, array<t<'a>>) => t<'a> 

@@ocaml.text("{2:run-decoders Run Decoders}")

type error 
@@ocaml.text("A structured error describing exactly how the decoder failed. You can use this to create more elaborate visualizations of a decoder problem. For example, you could show the entire JSON object and show the part causing the failure in red.")

@@ocaml.text("")
let decodeString: (string, t<'a>) => result<'a, error> 

type value = Js.Json.t
@@ocaml.text("Represents a JavaScript value.")

@@ocaml.text("")
let decodeValue: (value, t<'a>) => result<'a, error> 

@@ocaml.text("")
let errorToString: error => string 

@@ocaml.text("{2:combine Combine}")

@@ocaml.text("")
let map: (t<'a>, ~f: 'a => 'b) => t<'b> 

@@ocaml.text("")
let map2: (t<'a>, t<'b>, ~f: ('a, 'b) => 'c) => t<'c> 

@@ocaml.text("")
let map3: (t<'a>, t<'b>, t<'c>, ~f: ('a, 'b, 'c) => 'val) => t<'val> 

@@ocaml.text("")
let map4: (t<'a>, t<'b>, t<'c>, t<'d>, ~f: ('a, 'b, 'c, 'd) => 'val) => t<'val> 

@@ocaml.text("")
let map5: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, ~f: ('a, 'b, 'c, 'd, 'e) => 'val) => t<'val> 

@@ocaml.text("")
let map6: (
  t<'a>,
  t<'b>,
  t<'c>,
  t<'d>,
  t<'e>,
  t<'f>,
  ~f: ('a, 'b, 'c, 'd, 'e, 'f) => 'val,
) => t<'val> 

@@ocaml.text("")
let map7: (
  t<'a>,
  t<'b>,
  t<'c>,
  t<'d>,
  t<'e>,
  t<'f>,
  t<'g>,
  ~f: ('a, 'b, 'c, 'd, 'e, 'f, 'g) => 'val,
) => t<'val> 

@@ocaml.text("")
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
) => t<'val> 

@@ocaml.text("")
let andMap: (t<'a => 'b>, t<'a>) => t<'b> 

@@ocaml.text("{2:fancy Fancy}")

@@ocaml.text("")
let null: 'a => t<'a> 

@@ocaml.text("")
let value: t<value> 

@@ocaml.text("")
let andThen: (t<'a>, ~f: 'a => t<'b>) => t<'b> 

@@ocaml.text("")
let succeed: 'a => t<'a> 

@@ocaml.text("")
let fail: string => t<'a> 

