@@ocaml.text("Turn JSON values into Rescript values")

@@ocaml.text("{1:primitives Primitives}")

type t<'a>
@@ocaml.text("A value that knows how to decode JSON values.")

let string: t<string>
@@ocaml.text("
Decode a JSON string into a Rescript [string].

{[
  decodeString(\"true\", string)               == Error(...)
  decodeString(\"42\", string)                 == Error(...)
  decodeString(\"3.14\", string)               == Error(...)
  decodeString(\"\\\"hello\\\"\", string)          == Ok(\"hello\")
  decodeString(\"{ \\\"hello\\\": 42 }\", string)  == Error(...)
]}
")

let bool: t<bool>
@@ocaml.text("
Decode a JSON bool into a Rescript [bool].

{[
  decodeString(\"true\", bool)                == Ok(true)
  decodeString(\"42\", bool)                  == Error(...)
  decodeString(\"3.14\", bool)                == Error(...)
  decodeString(\"\\\"hello\\\"\", bool)           == Error(...)
  decodeString(\"{ \\\"hello\\\": 42 }\", bool)   == Error(...)
]}
")

let int: t<int>
@@ocaml.text("
Decode a JSON int into a Rescript [int].

{[
  decodeString(\"true\", int)              == Error(...)
  decodeString(\"42\", int)                == Ok(42)
  decodeString(\"3.14\", int)              == Error(...)
  decodeString(\"\\\"hello\\\"\", int)         == Error(...)
  decodeString(\"{ \\\"hello\\\": 42 }\", int) == Error(...)
]}
")

let float: t<float>
@@ocaml.text("
Decode a JSON float into a Rescript [float].

{[
  decodeString(\"true\", float)              == Error(...)
  decodeString(\"42\", float)                == Error(...)
  decodeString(\"3.14\", float)              == Ok(3.14)
  decodeString(\"\\\"hello\\\"\", float)         == Error(...)
  decodeString(\"{ \\\"hello\\\": 42 }\", float) == Error(...)
]}
")

@@ocaml.text("{1:data-structures Data Structures}")

let nullable: t<'a> => t<option<'a>>
@@ocaml.text("
Decode a nullable JSON value into a Rescript value.

{[
  decodeString(\"13\", nullable(int))   == Ok(Some(13))
  decodeString(\"42\", nullable(int))   == Ok(Some(42))
  decodeString(\"null\", nullable(int)) == Ok(None)
  decodeString(\"true\", nullable(int)) == Error(...)
]}
")

let array: t<'a> => t<array<'a>>
@@ocaml.text("
Decode a JSON value into a Rescript [array].

{[
  decodeString(\"[1,2,3]\", array(int))      == Ok([1, 2, 3])
  decodeString(\"[true,false]\", array(int)) == Ok([true, false])
]}
")

let list: t<'a> => t<list<'a>>
@@ocaml.text("
Decode a JSON value into a Rescript [list].

{[
  decodeString(\"[1,2,3]\", list(int))      == Ok(list{1, 2, 3})
  decodeString(\"[true,false]\", list(int)) == Ok(list{true, false})
]}
")

let dict: t<'a> => t<Js.Dict.t<'a>>
@@ocaml.text("
Decode a JSON value into a Rescript [Js.Dict.t].

{[
  decodeString(\"{ \\\"alice\\\": 42, \\\"bob\\\": 99 }\", dict(int))
    == Ok(Js.Dict.fromArray([(\"alice\", 42), (\"bob\", 99)]))
]}
")

let keyValuePairs: t<'a> => t<array<(string, 'a)>>
@@ocaml.text("
Decode a JSON value into a Rescript [array] of pair.

{[
  decodeString(\"{ \\\"alice\\\": 42, \\\"bob\\\": 99 }\", keyValuePairs(int))
    == Ok([(\"alice\", 42), (\"bob\", 99)])
]}
")

let tuple2: (t<'a>, t<'b>) => t<('a, 'b)>
@@ocaml.text("
Decode a JSON value into a Rescript tuple with 2 elements.

This is helpful if you're dealing with a heterogeneous JSON array, like [[1, \"hey\"]]. {e Modeling your JSON like this is generally a bad idea.} Unfortunatly, we sometimes have to use JSON/JavaScript from places outside our control, hence these functions.

{[
  decodeString(\"[1, \\\"hey\\\"]\", tuple2(int, string)) == Ok((1, \"hey\"))
    == Ok((1, \"hey\"))
]}
")

let tuple3: (t<'a>, t<'b>, t<'c>) => t<('a, 'b, 'c)>
@@ocaml.text("
Decode a JSON value into a Rescript tuple with 3 elements.

{[
  decodeString(\"[1, 8.0, \\\"hey\\\"]\", tuple3(int, float, string)) == Ok((1, \"hey\"))
    == Ok((1, 8., \"hey\"))
]}
")

@@ocaml.text(
  "For {! tuple4}-{! tuple8}, using it is just like the examples for [tuple2] and [tuple3] only with more elements & decoders."
)

let tuple4: (t<'a>, t<'b>, t<'c>, t<'d>) => t<('a, 'b, 'c, 'd)>

let tuple5: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>) => t<('a, 'b, 'c, 'd, 'e)>

let tuple6: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, t<'f>) => t<('a, 'b, 'c, 'd, 'e, 'f)>

let tuple7: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, t<'f>, t<'g>) => t<('a, 'b, 'c, 'd, 'e, 'f, 'g)>

let tuple8: (
  t<'a>,
  t<'b>,
  t<'c>,
  t<'d>,
  t<'e>,
  t<'f>,
  t<'g>,
  t<'h>,
) => t<('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h)>

@@ocaml.text("{1:obj-primitives Object Primitives}")

let field: (string, t<'a>) => t<'a>
@@ocaml.text("
Decode a JSON object, requiring a particular field.

{[
  decodeString(\"{ \\\"x\\\": 42 }\",             field(\"x\", int))== Ok(42)
  decodeString(\"{ \\\"x\\\": 42, \\\"y\\\": 50 }\",  field(\"x\", int))== Ok(42)
  decodeString(\"{ \\\"x\\\": true }\",           field(\"x\", int))== Error(...)
  decodeString(\"{ \\\"y\\\": 50 }\",             field(\"x\", int))== Error(...)
]}


The object {e can} have other fields. Lots of them! The only thing this decoder cares about is if [x] is present and that the value there is an [int].

Check out {! map2} to see how to decode multiple fields!
")

let at: (string, array<string>, t<'a>) => t<'a>
@@ocaml.text("
Decode a nested JSON object, requiring certain fields.

{[
  let json = \"{ \\\"person\\\": { \\\"name\\\": \\\"Maria\\\", \\\"age\\\": 24 } }\"

  decodeString(json, at([\"person\", \"name\"], string)) == Ok(\"Maria\")
  decodeString(json, at([\"person\", \"age\" ], int   )) == Ok(24)
]}

This is really just a shorthand for saying things like:
{[
  field(\"person\", field(\"name\"), string)) == at([\"person\", \"name\"], string)
]}
")

let index: (int, t<'a>) => t<'a>
@@ocaml.text("
Decode a nested JSON object, requiring a certain index.

{[
  let json = \"[ \\\"Maria\\\", \\\"Caleb\\\", \\\"Sofia\\\" ]\"

  decodeString(json, index(0, string)) == Ok(\"Maria\")
  decodeString(json, index(2, string)) == Ok(\"Sofia\")
]}
")

@@ocaml.text("{1:inconsisent-structur Inconsistent Structure}")

let option: t<'a> => t<option<'a>>
@@ocaml.text("
Helpful for dealing with optional fields. Here are a few slightly different examples:

{[
  let json = \"{ \\\"name\\\": \\\"Maria\\\", \\\"age\\\": 24 }\"

  decodeString(json, option(field(\"age\",    int  ))) == Ok(Some(24))
  decodeString(json, option(field(\"name\",   int  ))) == Ok(None)
  decodeString(json, option(field(\"height\", float))) == Ok(None)

  decodeString(json, field(\"height\", option(float))) == Ok(Some(24))
  decodeString(json, field(\"height\", option(float))) == Ok(None)
  decodeString(json, field(\"height\", option(float))) == Error(...)
]}


Notice the last example! It is saying we {e must} have a field named [height] and the content {e may} be a [float]. There is no [height] field, so the decoder fails.

Point is, [option] will make exactly what it contains conditional. For optional fields, this means you probably want it {e outside} a use of [field] or [at].
")

let oneOf: (t<'a>, array<t<'a>>) => t<'a>
@@ocaml.text("
Try a bunch of different decoders. This can be useful if the JSON may come in a couple different formats. For example, say you want to read an array of numbers, but some of them are [null].

{[
  let badIntDecoder: t<int> =
    oneOf(
      int, // the first decoder to try
      [null(0)] // the other decoders to try
    )

  decodeString(\"[1,2,null,4]\", badIntDecoder) == Ok([1, 2, 0, 4])
]}

Why would someone generate JSON like this? Questions like this are not good for your health. Point is, that you can use [oneOf] to handle situations like this!

You could also use [oneOf] to help version your data. Try the latest format, then a few older ones that you still support. You could use {! andThen} to be even more particular if you wanted.
")

@@ocaml.text("{1:run-decoders Run Decoders}")

type value = Js.Json.t
@@ocaml.text("Represents a JavaScript value.")

type rec error =
  | Failure(string, value)
  | Index(int, error)
  | Field(string, error)
  | OneOf(error, array<error>)
@@ocaml.text(
  "A structured error describing exactly how the decoder failed. You can use this to create more elaborate visualizations of a decoder problem. For example, you could show the entire JSON object and show the part causing the failure in red."
)

let decodeString: (string, t<'a>) => result<'a, error>
@@ocaml.text("
Parse the given string into a JSON value and then run the decoder on it. This will fail if the string is not well-formed JSON or if the Decoder fails for some reason.

{[
  decodeString(\"1\", int)     == Ok(1)
  decodeString(\"1 + 2\", int) == Error(...)
]}
")

let decodeValue: (value, t<'a>) => result<'a, error>
@@ocaml.text("
Run a decoder on some JSON `value`. This is helpful if you want to bring in some JavaScript value as a `value`, then run a decoder on it.

{[
  @module(\"my-func\")
  external getUser: unit => value = \"default\"

  let firstNameDecoder: t<string> =
    oneOf(
      field(\"firstName\", string),
      [
        field(\"first_name\", string),
        field(\"first-name\", string),
      ]
    )

  let myFunc = () => {
    getUser()
      ->decodeValue(firstNameDecoder)
  }
]}

")

let errorToString: error => string
@@ocaml.text("
Convert a decoding error into a [string] that is nice for debugging. The output of this function produces a multi-line string.

For example, the following decoder
{[
  decodeString(`{ \"a\": { \"b\": \"hey\" } }`, at(\"a\", [\"b\"], int))
]}
produces
{v
Problem with the value at json[\"a\"][\"b\"]:

\"hey\"

Expecting an INT
v}

{b Note}: It would be cool to do nicer coloring, but for now I'm just keeping it simple. It is totally possible to crawl the [error] variant and create this separately though! You can always checkout the source to see how this function works.
")

@@ocaml.text("{1:combine Combine}

Note: If you run out of map functions, take a look at {! andMap} which makes it easier to handle large objects, but produces lower quality type errors.
")

let map: (t<'a>, ~f: 'a => 'b) => t<'b>
@@ocaml.text("
Transform a decoder. Maybe you just want to know the length of a string:

{[
  let stringLength: t<int> = map(int, ~f=Js.Array.length)
]}

It is often helpful to use [map] with {! oneOf}, like when defining {! nullable}:

{[
  let nullable = (decoder: t<'a>): t<option<'a>> =
    oneOf(
      null(None),
      [map(decoder, ~f=val => Some(val))]
    )
]}

")

let map2: (t<'a>, t<'b>, ~f: ('a, 'b) => 'c) => t<'c>
@@ocaml.text("
Try two decoders and then combine the result. We can use this to decode objects with many fields:

{[
  type point = { x: float, y: float }

  let pointDecoder =
    map2(
      field(\"x\", float),
      field(\"y\", float),
      ~f=(x, y) => { x: x, y: y })
    )

  let json = \"{ \\\"x\\\": 2, \\\"y\\\": 5 }\"
  decodeString(json, pointDecoder) == Ok({ x: 2, y: 5 })
]}

It tries each individual decoder and puts the result together with in the [~f] function.
")

let map3: (t<'a>, t<'b>, t<'c>, ~f: ('a, 'b, 'c) => 'val) => t<'val>
@@ocaml.text("
Try three decoders and then combine the result. We can use this to decode objects with many fields:

{[
  type person = { name: string, age: int, height: float }

  let pointDecoder =
    map3(
      field(\"name\", string),
      at(\"info\", [\"age\"], int),
      at(\"info\", [\"height\"], float),
      ~f=(name, age, height) => { name: name, age: age, height: height })
    )

  let json = \"{ \\\"name\\\": \"Maria\", \\\"info\\\": { \\\"age\\\": 28, \\\"height\\\": 1.5 } }\"
  decodeString(json, pointDecoder)
    == Ok({ name: \"Maria\", age: 28, height: 1.5 })
]}

It tries each individual decoder and puts the result together with in the [~f] function.
")

@@ocaml.text(
  "For {! map4}-{! map8}, using it is just like the examples for {! map2} and {! map3} only with more elements & decoders."
)

let map4: (t<'a>, t<'b>, t<'c>, t<'d>, ~f: ('a, 'b, 'c, 'd) => 'val) => t<'val>

let map5: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, ~f: ('a, 'b, 'c, 'd, 'e) => 'val) => t<'val>

let map6: (
  t<'a>,
  t<'b>,
  t<'c>,
  t<'d>,
  t<'e>,
  t<'f>,
  ~f: ('a, 'b, 'c, 'd, 'e, 'f) => 'val,
) => t<'val>

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

@@ocaml.text("{1:fancy Fancy}")

let value: t<value>
@@ocaml.text("
  Do not do anything with a JSON value, just bring it into Rescript as a [value]. This can be useful if you have particularly complex data that you would like to deal with later. Or if you are going to send it out another [external] and do not care about its structure.
")

let null: 'a => t<'a>
@@ocaml.text("
Decode a JSON string into some Rescript value.

{[
  decodeString(\"null\", null(false)) == Ok(false)
  decodeString(\"null\", null(42))    == Ok(42)
  decodeString(\"42\", null(42))      == Error(...)
  decodeString(\"false\", null(42))   == Error(...)
]}
")

let succeed: 'a => t<'a>
@@ocaml.text("
Ignore the JSON and produce a certain Rescript value.

{[
  decodeString(\"true\", succeed(42))    == Ok(42)
  decodeString(\"[1,2,3]\", succeed(42)) == Ok(42)
  decodeString(\"hello\", succeed(42))   == Error(...) // \"hello\" is not a valid JSON string, so this fails
]}
")

let fail: string => t<'a>
@@ocaml.text("
Ignore the JSON and make the decoder fail. This is handy when used with {! oneOf} or {! andThen} where you want to give a custom error message in some case.

See the {! andThen} docs for an example.
")

let andMap: (t<'a => 'b>, t<'a>) => t<'b>
@@ocaml.text("
Chain decoders together and then transfrom them all together. This is very often going to be used with {! succeed}.

If you want to define {! map3}, you could do:
{[
  let map3: (t<'a>, t<'b>, t<'c>, ~f: ('a, 'b, 'c) => 'val) => t<'val> = (
    decoderA,
    decoderB,
    decoderC,
    ~f,
  ) =>
    succeed(f)
      ->andMap(decoderA)
      ->andMap(decoderB)
      ->andMap(decoderC)
]}
")

let andThen: (t<'a>, ~f: 'a => t<'b>) => t<'b>
@@ocaml.text("
Create decoders that depend on previous results. If you are creating versioned data, you might do something like this:

{[
  let infoDecoder1: t<info> = ...
  let infoDecoder2: t<info> = ...
  let infoDecoder3: t<info> = ...

  let infoHelp = (version: int): t<info> =
    switch version {
    | 1 => infoDecoder1
    | 2 => infoDecoder2
    | 3 => infoDecoder3
    | _ => fail(`Trying to decode info, but version ${Belt.Int.toString(version)} is not supported`)
    }

  let info: t<info> =
    field(\"version\", int)
      ->andThen(~f=infoHelp)
]}
")
