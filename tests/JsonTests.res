open Zora

zora("decode tests", t => {
  open! Json.Decode

  t->test("should decode a string", t => {
    t->equal(`"value"`->decodeString(string), Ok("value"), "Should equal")
    done()
  })

  t->test("should decode an int", t => {
    t->equal(`1`->decodeString(int), Ok(1), "Should equal")
    done()
  })

  t->test("should decode an float", t => {
    t->equal(`1`->decodeString(float), Ok(1.), "Should equal")
    done()
  })

  t->test("should decode an bool", t => {
    t->equal(`true`->decodeString(bool), Ok(true), "Should equal")
    done()
  })

  t->test("should decode null", t => {
    t->equal(`null`->decodeString(null(1)), Ok(1), "Should equal")
    done()
  })

  t->test("should decode empty array", t => {
    t->equal(`[]`->decodeString(array(int)), Ok([]), "Should equal")
    done()
  })

  t->test("should decode array", t => {
    t->equal(`[1, 2, 3]`->decodeString(array(int)), Ok([1, 2, 3]), "Should equal")
    done()
  })

  t->test("should decode empty list", t => {
    t->equal(`[]`->decodeString(list(int)), Ok(list{}), "Should equal")
    done()
  })

  t->test("should decode list", t => {
    t->equal(`[1, 2, 3]`->decodeString(list(int)), Ok(list{1, 2, 3}), "Should equal")
    done()
  })

  t->test("should decode array", t => {
    let res = Js.Dict.empty()
    res->Js.Dict.set("a", 1)
    res->Js.Dict.set("b", 2)
    t->equal(`{ "a": 1, "b": 2 }`->decodeString(dict(int)), Ok(res), "Should equal")
    done()
  })

  t->test("should decode empty key/value pair", t => {
    t->equal(`{}`->decodeString(keyValuePairs(int)), Ok([]), "Should equal")
    done()
  })

  t->test("should decode empty key/value pair", t => {
    t->equal(
      `{ "a": 1, "b": 2 }`->decodeString(keyValuePairs(int)),
      Ok([("a", 1), ("b", 2)]),
      "Should equal",
    )
    done()
  })

  t->test("should decode tuple2", t => {
    t->equal(`[1, "a"]`->decodeString(tuple2(int, string)), Ok((1, "a")), "Should equal")
    done()
  })

  t->test("should decode tuple6", t => {
    t->equal(
      `[1, "a", 3, 4, 5, 6]`->decodeString(tuple6(int, string, int, int, float, int)),
      Ok((1, "a", 3, 4, 5., 6)),
      "Should equal",
    )
    done()
  })

  t->test("should decode field", t => {
    t->equal(`{ "a": 1, "b": 2 }`->decodeString(field("a", int)), Ok(1), "Should equal")
    done()
  })

  t->test("should decode field at topLevle", t => {
    t->equal(
      `{ "a": { "c": "test" }, "b": 2 }`->decodeString(at("b", [], int)),
      Ok(2),
      "Should equal",
    )
    done()
  })

  t->test("should decode field at", t => {
    t->equal(
      `{ "a": { "c": "test" }, "b": 2 }`->decodeString(at("a", ["c"], string)),
      Ok("test"),
      "Should equal",
    )
    done()
  })

  t->test("should decode array at index", t => {
    t->equal(`[1, 2, 3]`->decodeString(index(0, int)), Ok(1), "Should equal")
    done()
  })

  t->test("should decode optional bool valid", t => {
    t->equal(`false`->decodeString(option(bool)), Ok(Some(false)), "Should equal")
    done()
  })

  t->test("should decode optional bool invalid", t => {
    t->equal(`1`->decodeString(option(bool)), Ok(None), "Should equal")
    done()
  })

  t->test("should decode oneOf first", t => {
    t->equal(`1`->decodeString(oneOf(float, [])), Ok(1.), "Should equal")
    done()
  })

  t->test("should decode oneOf second", t => {
    t->equal(
      `{ "b": 1 }`->decodeString(oneOf(field("a", int), [field("b", int)])),
      Ok(1),
      "Should equal",
    )
    done()
  })

  t->test("should decode oneOf third", t => {
    t->equal(
      `{ "b": 1 }`->decodeString(oneOf(field("a", int), [field("c", int), field("b", int)])),
      Ok(1),
      "Should equal",
    )
    done()
  })

  t->test("should decode value", t => {
    let resValue = decodeString("1", value)
    switch resValue {
    | Ok(value) => t->equal(decodeValue(value, float), Ok(1.), "Should equal")
    | Error(_) => t->Zora.fail("Shouldn't have failed")
    }
    done()
  })

  t->test("should be able to map", t => {
    t->equal("2"->decodeString(int->map(~f=i => i + 1)), Ok(2), "Should equal")
    done()
  })

  t->test("should be able to map2", t => {
    t->equal(
      `{ "a": "hi", "b": 3 }`->decodeString(
        map2(field("a", string), field("b", int), ~f=(a, b) => Js.String.length(a) * b),
      ),
      Ok(6),
      "Should equal",
    )
    done()
  })

  t->test("should be able to map3", t => {
    t->equal(
      `{ "a": "hi", "b": 3, "c": 3 }`->decodeString(
        map3(field("a", string), field("b", int), field("c", int), ~f=(a, b, c) =>
          Js.String.length(a) * b + c
        ),
      ),
      Ok(9),
      "Should equal",
    )
    done()
  })

  t->test("should decode an nullable valid", t => {
    t->equal(`1`->decodeString(nullable(float)), Ok(Some(1.)), "Should equal")
    done()
  })

  t->test("should decode an nullable null", t => {
    t->equal(`null`->decodeString(nullable(float)), Ok(None), "Should equal")
    done()
  })

  t->test("should not decode an nullable invalid", t => {
    t->resultError(`a`->decodeString(nullable(float)), "Should be error")
    done()
  })

  t->test("should succeed", t => {
    t->equal(`"value"`->decodeString(succeed(true)), Ok(true), "Should equal")
    done()
  })

  t->test("should fail", t => {
    t->resultError(`"value"`->decodeString(fail("bad")), "Should be error")
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
