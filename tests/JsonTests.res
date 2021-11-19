open Zora

zora("decode tests", t => {
  open! Json.Decode

  t->test("should decode a string", t => {
    t->equal(decodeString(`"value"`, string), Ok("value"), "Should equal")
    done()
  })

  t->test("should decode an int", t => {
    t->equal(decodeString(`1`, int), Ok(1), "Should equal")
    done()
  })

  t->test("should decode an float", t => {
    t->equal(decodeString(`1`, float), Ok(1.), "Should equal")
    done()
  })

  t->test("should decode an bool", t => {
    t->equal(decodeString(`true`, bool), Ok(true), "Should equal")
    done()
  })

  t->test("should decode null", t => {
    t->equal(decodeString(`null`, null(1)), Ok(1), "Should equal")
    done()
  })

  t->test("should decode empty array", t => {
    t->equal(decodeString(`[]`, array(int)), Ok([]), "Should equal")
    done()
  })

  t->test("should decode array", t => {
    t->equal(decodeString(`[1, 2, 3]`, array(int)), Ok([1, 2, 3]), "Should equal")
    done()
  })

  t->test("should decode empty list", t => {
    t->equal(decodeString(`[]`, list(int)), Ok(list{}), "Should equal")
    done()
  })

  t->test("should decode list", t => {
    t->equal(decodeString(`[1, 2, 3]`, list(int)), Ok(list{1, 2, 3}), "Should equal")
    done()
  })

  t->test("should decode array", t => {
    let res = Js.Dict.empty()
    res->Js.Dict.set("a", 1)
    res->Js.Dict.set("b", 2)
    t->equal(decodeString(`{ "a": 1, "b": 2 }`, dict(int)), Ok(res), "Should equal")
    done()
  })

  t->test("should decode empty key/value pair", t => {
    t->equal(decodeString(`{}`, keyValuePairs(int)), Ok([]), "Should equal")
    done()
  })

  t->test("should decode empty key/value pair", t => {
    t->equal(
      decodeString(`{ "a": 1, "b": 2 }`, keyValuePairs(int)),
      Ok([("a", 1), ("b", 2)]),
      "Should equal",
    )
    done()
  })

  t->test("should decode tuple2", t => {
    t->equal(decodeString(`[1, "a"]`, tuple2(int, string)), Ok((1, "a")), "Should equal")
    done()
  })

  t->test("should decode tuple6", t => {
    t->equal(
      decodeString(`[1, "a", 3, 4, 5, 6]`, tuple6(int, string, int, int, float, int)),
      Ok((1, "a", 3, 4, 5., 6)),
      "Should equal",
    )
    done()
  })

  t->test("should decode field", t => {
    t->equal(decodeString(`{ "a": 1, "b": 2 }`, field("a", int)), Ok(1), "Should equal")
    done()
  })

  t->test("should decode field at topLevle", t => {
    t->equal(
      decodeString(`{ "a": { "c": "test" }, "b": 2 }`, at("b", [], int)),
      Ok(2),
      "Should equal",
    )
    done()
  })

  t->test("should decode field at", t => {
    t->equal(
      decodeString(`{ "a": { "c": "test" }, "b": 2 }`, at("a", ["c"], string)),
      Ok("test"),
      "Should equal",
    )
    done()
  })

  t->test("should decode array at index", t => {
    t->equal(decodeString(`[1, 2, 3]`, index(0, int)), Ok(1), "Should equal")
    done()
  })

  t->test("should decode optional bool valid", t => {
    t->equal(decodeString(`false`, option(bool)), Ok(Some(false)), "Should equal")
    done()
  })

  t->test("should decode optional bool invalid", t => {
    t->equal(decodeString(`1`, option(bool)), Ok(None), "Should equal")
    done()
  })

  t->test("should decode oneOf first", t => {
    t->equal(decodeString(`1`, oneOf(float, [])), Ok(1.), "Should equal")
    done()
  })

  t->test("should decode oneOf second", t => {
    t->equal(
      decodeString(`{ "b": 1 }`, oneOf(field("a", int), [field("b", int)])),
      Ok(1),
      "Should equal",
    )
    done()
  })

  t->test("should decode oneOf third", t => {
    t->equal(
      decodeString(`{ "b": 1 }`, oneOf(field("a", int), [field("c", int), field("b", int)])),
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
    t->equal(decodeString(`1`, int->map(~f=i => i + 1)), Ok(2), "Should equal")
    done()
  })

  t->test("should be able to map2", t => {
    t->equal(
      decodeString(
        `{ "a": "hi", "b": 3 }`,
        map2(field("a", string), field("b", int), ~f=(a, b) => Js.String.length(a) * b),
      ),
      Ok(6),
      "Should equal",
    )
    done()
  })

  t->test("should be able to map3", t => {
    t->equal(
      decodeString(
        `{ "a": "hi", "b": 3, "c": 3 }`,
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
    t->equal(decodeString(`1`, nullable(float)), Ok(Some(1.)), "Should equal")
    done()
  })

  t->test("should decode an nullable null", t => {
    t->equal(decodeString(`null`, nullable(float)), Ok(None), "Should equal")
    done()
  })

  t->test("should not decode an nullable invalid", t => {
    t->resultError(decodeString(`a`, nullable(float)), "Should be error")
    done()
  })

  t->test("should succeed", t => {
    t->equal(decodeString(`"value"`, succeed(true)), Ok(true), "Should equal")
    done()
  })

  t->test("should fail", t => {
    t->resultError(decodeString(`"value"`, fail("bad")), "Should be error")
    done()
  })

  done()
})

zora("encode tests", t => {
  open! Json.Encode

  t->test("should encode a string", t => {
    t->equal(encode(string("value"), 0), `"value"`, "Should equal")
    done()
  })

  t->test("should encode a int", t => {
    t->equal(encode(int(1), 0), `1`, "Should equal")
    done()
  })

  t->test("should encode a float", t => {
    t->equal(encode(float(1.), 0), `1`, "Should equal")
    done()
  })

  t->test("should encode a bool", t => {
    t->equal(encode(bool(true), 0), `true`, "Should equal")
    done()
  })

  t->test("should encode a null", t => {
    t->equal(encode(null, 0), `null`, "Should equal")
    done()
  })

  t->test("should encode an empty array", t => {
    t->equal(encode(array([], int), 0), `[]`, "Should equal")
    done()
  })

  t->test("should encode an array", t => {
    t->equal(encode(array([1, 2], int), 0), `[1,2]`, "Should equal")
    done()
  })

  t->test("should encode an empty list", t => {
    t->equal(encode(list(list{}, int), 0), `[]`, "Should equal")
    done()
  })

  t->test("should encode an list", t => {
    t->equal(encode(list(list{1, 2}, int), 0), `[1,2]`, "Should equal")
    done()
  })

  t->test("should encode an empty object", t => {
    t->equal(encode(object([]), 0), `{}`, "Should equal")
    done()
  })

  t->test("should encode an object", t => {
    t->equal(encode(object([("a", int(1))]), 0), `{"a":1}`, "Should equal")
    done()
  })

  t->test("should encode an empty dict", t => {
    t->equal(encode(dict(Js.Dict.empty()), 0), `{}`, "Should equal")
    done()
  })

  t->test("should encode an dict", t => {
    let d = Js.Dict.empty()
    d->Js.Dict.set("a", int(1))
    t->equal(encode(dict(d), 0), `{"a":1}`, "Should equal")
    done()
  })

  done()
})
