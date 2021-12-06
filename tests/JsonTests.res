open Zora

zora("decode tests", t => {
  open! Json.Decode

  t->test("should decode a string", t => {
    t->equal(decodeString(string, `"value"`), Ok("value"), "Should equal")
    done()
  })

  t->test("should decode an int", t => {
    t->equal(decodeString(int, `1`), Ok(1), "Should equal")
    done()
  })

  t->test("should decode an float", t => {
    t->equal(decodeString(float, `1`), Ok(1.), "Should equal")
    done()
  })

  t->test("should decode an bool", t => {
    t->equal(decodeString(bool, `true`), Ok(true), "Should equal")
    done()
  })

  t->test("should decode null", t => {
    t->equal(decodeString(null(1), `null`), Ok(1), "Should equal")
    done()
  })

  t->test("should decode empty array", t => {
    t->equal(decodeString(array(int), `[]`), Ok([]), "Should equal")
    done()
  })

  t->test("should decode array", t => {
    t->equal(decodeString(array(int), `[1, 2, 3]`), Ok([1, 2, 3]), "Should equal")
    done()
  })

  t->test("should decode empty list", t => {
    t->equal(decodeString(list(int), `[]`), Ok(list{}), "Should equal")
    done()
  })

  t->test("should decode list", t => {
    t->equal(decodeString(list(int), `[1, 2, 3]`), Ok(list{1, 2, 3}), "Should equal")
    done()
  })

  t->test("should decode array", t => {
    let res = Js.Dict.empty()
    res->Js.Dict.set("a", 1)
    res->Js.Dict.set("b", 2)
    t->equal(decodeString(dict(int), `{ "a": 1, "b": 2 }`), Ok(res), "Should equal")
    done()
  })

  t->test("should decode empty key/value pair", t => {
    t->equal(decodeString(keyValuePairs(int), `{}`), Ok([]), "Should equal")
    done()
  })

  t->test("should decode empty key/value pair", t => {
    t->equal(
      decodeString(keyValuePairs(int), `{ "a": 1, "b": 2 }`),
      Ok([("a", 1), ("b", 2)]),
      "Should equal",
    )
    done()
  })

  t->test("should decode tuple2", t => {
    t->equal(decodeString(tuple2(int, string), `[1, "a"]`), Ok((1, "a")), "Should equal")
    done()
  })

  t->test("should decode tuple6", t => {
    t->equal(
      decodeString(tuple6(int, string, int, int, float, int), `[1, "a", 3, 4, 5, 6]`),
      Ok((1, "a", 3, 4, 5., 6)),
      "Should equal",
    )
    done()
  })

  t->test("should decode field", t => {
    t->equal(decodeString(field("a", int), `{ "a": 1, "b": 2 }`), Ok(1), "Should equal")
    done()
  })

  t->test("should decode field at topLevle", t => {
    t->equal(
      decodeString(at("b", [], int), `{ "a": { "c": "test" }, "b": 2 }`),
      Ok(2),
      "Should equal",
    )
    done()
  })

  t->test("should decode field at", t => {
    t->equal(
      decodeString(at("a", ["c"], string), `{ "a": { "c": "test" }, "b": 2 }`),
      Ok("test"),
      "Should equal",
    )
    done()
  })

  t->test("should decode array at index", t => {
    t->equal(decodeString(index(0, int), `[1, 2, 3]`), Ok(1), "Should equal")
    done()
  })

  t->test("should decode optional bool valid", t => {
    t->equal(decodeString(option(bool), `false`), Ok(Some(false)), "Should equal")
    done()
  })

  t->test("should decode optional bool invalid", t => {
    t->equal(decodeString(option(bool), `1`), Ok(None), "Should equal")
    done()
  })

  t->test("should decode oneOf first", t => {
    t->equal(decodeString(oneOf(float, []), `1`), Ok(1.), "Should equal")
    done()
  })

  t->test("should decode oneOf second", t => {
    t->equal(
      decodeString(oneOf(field("a", int), [field("b", int)]), `{ "b": 1 }`),
      Ok(1),
      "Should equal",
    )
    done()
  })

  t->test("should decode oneOf third", t => {
    t->equal(
      decodeString(oneOf(field("a", int), [field("c", int), field("b", int)]), `{ "b": 1 }`),
      Ok(1),
      "Should equal",
    )
    done()
  })

  t->test("should decode value", t => {
    let resValue = decodeString(value, "1")
    switch resValue {
    | Ok(value) => t->equal(decodeValue(float, value), Ok(1.), "Should equal")
    | Error(_) => t->Zora.fail("Shouldn't have failed")
    }
    done()
  })

  t->test("should be able to map", t => {
    t->equal(int->map(~f=i => i + 1)->decodeString(`1`), Ok(2), "Should equal")
    done()
  })

  t->test("should be able to map2", t => {
    t->equal(
      decodeString(
        map2(field("a", string), field("b", int), ~f=(a, b) => Js.String.length(a) * b),
        `{ "a": "hi", "b": 3 }`,
      ),
      Ok(6),
      "Should equal",
    )
    done()
  })

  t->test("should be able to map3", t => {
    t->equal(
      decodeString(
        map3(field("a", string), field("b", int), field("c", int), ~f=(a, b, c) =>
          Js.String.length(a) * b + c
        ),
        `{ "a": "hi", "b": 3, "c": 3 }`,
      ),
      Ok(9),
      "Should equal",
    )
    done()
  })

  t->test("should decode an nullable valid", t => {
    t->equal(decodeString(nullable(float), `1`), Ok(Some(1.)), "Should equal")
    done()
  })

  t->test("should decode an nullable null", t => {
    t->equal(decodeString(nullable(float), `null`), Ok(None), "Should equal")
    done()
  })

  t->test("should not decode an nullable invalid", t => {
    t->resultError(decodeString(nullable(float), `a`), "Should be error")
    done()
  })

  t->test("should succeed", t => {
    t->equal(decodeString(succeed(true), `"value"`), Ok(true), "Should equal")
    done()
  })

  t->test("should fail", t => {
    t->resultError(decodeString(fail("bad"), `"value"`), "Should be error")
    done()
  })

  done()
})

zora("encode tests", t => {
  open! Json.Encode

  t->test("should encode a string", t => {
    t->equal(encode(string("value"), ~indentLevel=0), `"value"`, "Should equal")
    done()
  })

  t->test("should encode a int", t => {
    t->equal(encode(int(1), ~indentLevel=0), `1`, "Should equal")
    done()
  })

  t->test("should encode a float", t => {
    t->equal(encode(float(1.), ~indentLevel=0), `1`, "Should equal")
    done()
  })

  t->test("should encode a bool", t => {
    t->equal(encode(bool(true), ~indentLevel=0), `true`, "Should equal")
    done()
  })

  t->test("should encode a null", t => {
    t->equal(encode(null, ~indentLevel=0), `null`, "Should equal")
    done()
  })

  t->test("should encode an empty array", t => {
    t->equal(encode(array([], int), ~indentLevel=0), `[]`, "Should equal")
    done()
  })

  t->test("should encode an array", t => {
    t->equal(encode(array([1, 2], int), ~indentLevel=0), `[1,2]`, "Should equal")
    done()
  })

  t->test("should encode an empty list", t => {
    t->equal(encode(list(list{}, int), ~indentLevel=0), `[]`, "Should equal")
    done()
  })

  t->test("should encode an list", t => {
    t->equal(encode(list(list{1, 2}, int), ~indentLevel=0), `[1,2]`, "Should equal")
    done()
  })

  t->test("should encode an empty object", t => {
    t->equal(encode(object([]), ~indentLevel=0), `{}`, "Should equal")
    done()
  })

  t->test("should encode an object", t => {
    t->equal(encode(object([("a", int(1))]), ~indentLevel=0), `{"a":1}`, "Should equal")
    done()
  })

  t->test("should encode an empty dict", t => {
    t->equal(encode(dict(Js.Dict.empty()), ~indentLevel=0), `{}`, "Should equal")
    done()
  })

  t->test("should encode an dict", t => {
    let d = Js.Dict.empty()
    d->Js.Dict.set("a", int(1))
    t->equal(encode(dict(d), ~indentLevel=0), `{"a":1}`, "Should equal")
    done()
  })

  t->test("should encode NaN to null", t => {
    t->equal(encode(float(Js.Float._NaN), ~indentLevel=0), `null`, "Should equal")
    done()
  })

  t->test("should encode Infinity to null", t => {
    t->equal(encode(float(infinity), ~indentLevel=0), `null`, "Should equal")
    done()
  })

  done()
})
