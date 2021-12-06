@@ocaml.text("Turn Rescript values into JSON values")

@@ocaml.text("{1:encoding Encoding}")

type value = Js.Json.t
@@ocaml.text("Represents a JavaScript value.")

let encode: (value, ~indentLevel: int) => string
@@ocaml.text("
Convert a [value] into a prettified string.

{[
  let maria: value =
    object([
      (\"name\", \"Maria\"),
      (\"age\", 26),
    ])

  encode(maria, 0)
  // {\"name\":\"Maria\",\"age\":26}

  encode(maria, 4)
  // {
  //     \"name\": \"Maria\",
  //     \"age\": 26
  // }

]}
")

@@ocaml.text("{1:primatives Primatives}")

let string: string => value
@@ocaml.text("
Turn a [string] into a Rescript value.

{[
  string(\"\")->encode(~indentLevel=0)      == \"\"
  string(\"abc\")->encode(~indentLevel=0)   == \"abc\"
  string(\"hello\")->encode(~indentLevel=0) == \"hello\"
]}
")

let int: int => value
@@ocaml.text("
Turn an [int] into a Rescript value.

{[
  int(42)->encode(~indentLevel=0) == \"42\"
  int(-7)->encode(~indentLevel=0) == \"-7\"
  int(0)->encode(~indentLevel=0)  == \"0\"
]}
")

let float: float => value
@@ocaml.text("
Turn a [float] into a Rescript value.

{[
  float(3.14)->encode(~indentLevel=0)           == \"3.14\"
  float(1.618)->encode(~indentLevel=0)          == \"1.618\"
  float(-42)->encode(~indentLevel=0)            == \"-42\"
  float(Js.Float._NaN)->encode(~indentLevel=0)  == \"null\"
  float(infinity)->encode(~indentLevel=0)       == \"null\"
]}

Note: Floating point numbers are defined in the {{: https://en.wikipedia.org/wiki/IEEE_754} IEEE 754} standard which is hardcoded into almost all CPUs. This standard allows `infinity` and `Js.Matn._NaN). The {{: https://www.json.org/json-en.html} JSON spec} does not include these values, so we encode them both as [null].
")

let bool: bool => value
@@ocaml.text("
Turn a [bool] into a Rescript value.

{[
  bool(true)->encode(~indentLevel=0)  == \"true\"
  bool(false)->encode(~indentLevel=0) == \"false\"
]}
")

let null: value
@@ocaml.text("
Create a [null] JSON value

{[
  null->encode(~indentLevel=0) == \"null\"
]}
")

@@ocaml.text("{1:arrays Arrays}")

let array: (array<'i>, 'i => value) => value
@@ocaml.text("
Turn an [array] into a JSON array.

{[
  array([1, 2, 3], int)->encode(~indentLevel=0)         == \"[1,2,3]\"
  array([true, false], bool)->encode(~indentLevel=0)    == \"[true,false]\"
  array([\"a\", \"b\"], string)->encode(~indentLevel=0)     == \"[\\\"a\\\",\\\"b\\\"]\"
]}
")

let list: (list<'i>, 'i => value) => value
@@ocaml.text("
Turn a [list] into a JSON array.

{[
  list(list{1, 2, 3}, int)->encode(~indentLevel=0)         == \"[1,2,3]\"
  list(list{true, false}, bool)->encode(~indentLevel=0)    == \"[true,false]\"
  list(list{\"a\", \"b\"}, string)->encode(~indentLevel=0)     == \"[\\\"a\\\",\\\"b\\\"]\"
]}
")

@@ocaml.text("{1:objects Objects}")

let object: array<(string, value)> => value
@@ocaml.text("
Create a JSON object.

{[
  let maria: value =
    object([
      (\"name\", \"Maria\"),
      (\"age\", 26),
    ])

  encode(maria, 0)
  // {\"name\":\"Maria\",\"age\":26}
]}
")

let dict: Js.Dict.t<value> => value
@@ocaml.text("
Turn a `Js.Dict.t` into a JSON object.

{[
  let maria: value =
    [
      (\"name\", \"Maria\"),
      (\"age\", 26),
    ]
    ->Js.Dict.fromArray

  encode(maria, 0)
  // {\"name\":\"Maria\",\"age\":26}
]}
")
