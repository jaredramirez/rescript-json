open Zora

zora("decoder tests", t => {
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
    t->equal(decodeString(int->map(i => i + 1), `1`), Ok(2), "Should equal")
    done()
  })

  t->test("should be able to map2", t => {
    t->equal(
      decodeString(
        map2(field("a", string), field("b", int), (a, b) => Js.String.length(a) * b),
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
        map3(field("a", string), field("b", int), field("c", int), (a, b, c) =>
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
