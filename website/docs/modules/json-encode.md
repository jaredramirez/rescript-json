---
sidebar_position: 5
---

# `Json.Encode`

Turn JSON values into Rescript values

## Encoding

### `value`

```rescript
type value = Js.Json.t
```
Represents a JavaScript value. Alias to [`Json.value`](./json#value);

### `encode`

```rescript
let encode: (value, ~indentLevel: int) => string
```

Convert a [value] into a prettified string. From here, you can send it as part of an HTTP request, send to Javascript with an `exeternal`, or anything else! The world is your oyster.

```rescript
let maria: value =
  object([
    ("name", "Maria"),
    ("age", 26),
  ])

encode(maria, 0) == "{"name":"Maria","age":26}"

encode(maria, 4) ==
"""{
    "name": "Maria",
    "age": 26
}"""
```

## Primatives

### `string`

```rescript
let string: string => value
```

Turn a `string` into a Rescript value.

```rescript
string("")->encode(~indentLevel=0)      == ""
string("abc")->encode(~indentLevel=0)   == "abc"
string("hello")->encode(~indentLevel=0) == "hello"
```

### `int`

```rescript
let int: int => value
```

Turn an `int` into a Rescript value.

```rescript
int(42)->encode(~indentLevel=0) == "42"
int(-7)->encode(~indentLevel=0) == "-7"
int(0)->encode(~indentLevel=0)  == "0"
```

### `float`

```rescript
let float: float => value
```

Turn a `float` into a Rescript value.

```rescript
float(3.14)->encode(~indentLevel=0)           == "3.14"
float(1.618)->encode(~indentLevel=0)          == "1.618"
float(-42)->encode(~indentLevel=0)            == "-42"
float(Js.Float._NaN)->encode(~indentLevel=0)  == "null"
float(infinity)->encode(~indentLevel=0)       == "null"
```

### `bool`

```rescript
let bool: bool => value
```

Turn a `bool` into a Rescript value.

```rescript
bool(true)->encode(~indentLevel=0)  == "true"
bool(false)->encode(~indentLevel=0) == "false"
```

### `null`

```rescript
let null: value
```

Create a `null` JSON value

```rescript
  null->encode(~indentLevel=0) == "null"
```

## Arrays

### `array`

```rescript
let array: (array<'i>, 'i => value) => value
```

Turn an `array` into a JSON array.

```rescript
array([1, 2, 3], int)->encode(~indentLevel=0)         == "[1,2,3]"
array([true, false], bool)->encode(~indentLevel=0)    == "[true,false]"
array(["a", "b"], string)->encode(~indentLevel=0)     == "[\"a\",\"b\"]"
```

What if you need to encode your Rescript into a heterogeneous JSON array, like `[1, "hey"]`? *Modeling your JSON like this is generally a bad idea.* Unfortunately, we sometimes have to send JSON/JavaScript to places outside our control. If this is the case for you, can use `array` like so:
```rescript
[int(1), string("Hey")]
  ->array(v => v)
  ->encode(~indentLevel=0)
  == "[1,\"Hey\"]"
```
In Rescript, you can't have an array of heterogenous values.
In this example with `[1, "Hey"]` our array type is `array<int | string>`, which is invalid Rescript.
*But*, if we convert those values to [`values`](#value) first, then our type is `array<value>`, which is totally valid Rescript!
Then for the 2nd function argument to `array`, which is normally converts each array element to a `value`, we just return the argument because it's already a `value`.

### `list`

```rescript
let list: (list<'i>, 'i => value) => value
```

Turn a `list` into a JSON array.

```rescript
list(list{1, 2, 3}, int)->encode(~indentLevel=0)         == "[1,2,3]"
list(list{true, false}, bool)->encode(~indentLevel=0)    == "[true,false]"
list(list{"a", "b"}, string)->encode(~indentLevel=0)     == "[\"a\",\"b\"]"
```

## Objects

### `object`

```rescript
let object: array<(string, value)> => value
```

Create a JSON object.

```rescript
let maria: value =
  object([
    ("name", "Maria"),
    ("age", 26),
  ])

encode(maria, 0) == "{\"name\":\"Maria\",\"age\":26}"
```

### `dict`

```rescript
let dict: Js.Dict.t<value> => value
```

Turn a `Js.Dict.t` into a JSON object.

```rescript
let maria: value =
  [
    ("name", "Maria"),
    ("age", 26),
  ]
  ->Js.Dict.fromArray

encode(maria, 0) == "{\"name\":\"Maria\",\"age\":26}"
```
