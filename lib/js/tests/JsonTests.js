// Generated by ReScript, PLEASE EDIT WITH CARE
'use strict';

var Zora = require("@dusty-phillips/rescript-zora/lib/js/src/Zora.js");
var Zora$1 = require("zora");
var Pervasives = require("rescript/lib/js/pervasives.js");
var Json__Decode = require("../src/Json__Decode.js");
var Json__Encode = require("../src/Json__Encode.js");

Zora$1.test("decode tests", (function (t) {
        t.test("should decode a string", (function (t) {
                t.equal(Json__Decode.decodeString("\"value\"", Json__Decode.string), {
                      TAG: /* Ok */0,
                      _0: "value"
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode an int", (function (t) {
                t.equal(Json__Decode.decodeString("1", Json__Decode.$$int), {
                      TAG: /* Ok */0,
                      _0: 1
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode an float", (function (t) {
                t.equal(Json__Decode.decodeString("1", Json__Decode.$$float), {
                      TAG: /* Ok */0,
                      _0: 1
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode an bool", (function (t) {
                t.equal(Json__Decode.decodeString("true", Json__Decode.bool), {
                      TAG: /* Ok */0,
                      _0: true
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode null", (function (t) {
                t.equal(Json__Decode.decodeString("null", Json__Decode.$$null(1)), {
                      TAG: /* Ok */0,
                      _0: 1
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode empty array", (function (t) {
                t.equal(Json__Decode.decodeString("[]", Json__Decode.array(Json__Decode.$$int)), {
                      TAG: /* Ok */0,
                      _0: []
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode array", (function (t) {
                t.equal(Json__Decode.decodeString("[1, 2, 3]", Json__Decode.array(Json__Decode.$$int)), {
                      TAG: /* Ok */0,
                      _0: [
                        1,
                        2,
                        3
                      ]
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode empty list", (function (t) {
                t.equal(Json__Decode.decodeString("[]", Json__Decode.list(Json__Decode.$$int)), {
                      TAG: /* Ok */0,
                      _0: /* [] */0
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode list", (function (t) {
                t.equal(Json__Decode.decodeString("[1, 2, 3]", Json__Decode.list(Json__Decode.$$int)), {
                      TAG: /* Ok */0,
                      _0: {
                        hd: 1,
                        tl: {
                          hd: 2,
                          tl: {
                            hd: 3,
                            tl: /* [] */0
                          }
                        }
                      }
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode array", (function (t) {
                var res = {};
                res["a"] = 1;
                res["b"] = 2;
                t.equal(Json__Decode.decodeString("{ \"a\": 1, \"b\": 2 }", Json__Decode.dict(Json__Decode.$$int)), {
                      TAG: /* Ok */0,
                      _0: res
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode empty key/value pair", (function (t) {
                t.equal(Json__Decode.decodeString("{}", Json__Decode.keyValuePairs(Json__Decode.$$int)), {
                      TAG: /* Ok */0,
                      _0: []
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode empty key/value pair", (function (t) {
                t.equal(Json__Decode.decodeString("{ \"a\": 1, \"b\": 2 }", Json__Decode.keyValuePairs(Json__Decode.$$int)), {
                      TAG: /* Ok */0,
                      _0: [
                        [
                          "a",
                          1
                        ],
                        [
                          "b",
                          2
                        ]
                      ]
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode tuple2", (function (t) {
                t.equal(Json__Decode.decodeString("[1, \"a\"]", Json__Decode.tuple2(Json__Decode.$$int, Json__Decode.string)), {
                      TAG: /* Ok */0,
                      _0: [
                        1,
                        "a"
                      ]
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode tuple6", (function (t) {
                t.equal(Json__Decode.decodeString("[1, \"a\", 3, 4, 5, 6]", Json__Decode.tuple6(Json__Decode.$$int, Json__Decode.string, Json__Decode.$$int, Json__Decode.$$int, Json__Decode.$$float, Json__Decode.$$int)), {
                      TAG: /* Ok */0,
                      _0: [
                        1,
                        "a",
                        3,
                        4,
                        5,
                        6
                      ]
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode field", (function (t) {
                t.equal(Json__Decode.decodeString("{ \"a\": 1, \"b\": 2 }", Json__Decode.field("a", Json__Decode.$$int)), {
                      TAG: /* Ok */0,
                      _0: 1
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode field at topLevle", (function (t) {
                t.equal(Json__Decode.decodeString("{ \"a\": { \"c\": \"test\" }, \"b\": 2 }", Json__Decode.at("b", [], Json__Decode.$$int)), {
                      TAG: /* Ok */0,
                      _0: 2
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode field at", (function (t) {
                t.equal(Json__Decode.decodeString("{ \"a\": { \"c\": \"test\" }, \"b\": 2 }", Json__Decode.at("a", ["c"], Json__Decode.string)), {
                      TAG: /* Ok */0,
                      _0: "test"
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode array at index", (function (t) {
                t.equal(Json__Decode.decodeString("[1, 2, 3]", Json__Decode.index(0, Json__Decode.$$int)), {
                      TAG: /* Ok */0,
                      _0: 1
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode optional bool valid", (function (t) {
                t.equal(Json__Decode.decodeString("false", Json__Decode.option(Json__Decode.bool)), {
                      TAG: /* Ok */0,
                      _0: false
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode optional bool invalid", (function (t) {
                t.equal(Json__Decode.decodeString("1", Json__Decode.option(Json__Decode.bool)), {
                      TAG: /* Ok */0,
                      _0: undefined
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode oneOf first", (function (t) {
                t.equal(Json__Decode.decodeString("1", Json__Decode.oneOf(Json__Decode.$$float, [])), {
                      TAG: /* Ok */0,
                      _0: 1
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode oneOf second", (function (t) {
                t.equal(Json__Decode.decodeString("{ \"b\": 1 }", Json__Decode.oneOf(Json__Decode.field("a", Json__Decode.$$int), [Json__Decode.field("b", Json__Decode.$$int)])), {
                      TAG: /* Ok */0,
                      _0: 1
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode oneOf third", (function (t) {
                t.equal(Json__Decode.decodeString("{ \"b\": 1 }", Json__Decode.oneOf(Json__Decode.field("a", Json__Decode.$$int), [
                              Json__Decode.field("c", Json__Decode.$$int),
                              Json__Decode.field("b", Json__Decode.$$int)
                            ])), {
                      TAG: /* Ok */0,
                      _0: 1
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode value", (function (t) {
                var resValue = Json__Decode.decodeString("1", Json__Decode.value);
                if (resValue.TAG === /* Ok */0) {
                  t.equal(Json__Decode.decodeValue(resValue._0, Json__Decode.$$float), {
                        TAG: /* Ok */0,
                        _0: 1
                      }, "Should equal");
                } else {
                  t.fail("Shouldn't have failed");
                }
                return Zora.done(undefined);
              }));
        t.test("should be able to map", (function (t) {
                t.equal(Json__Decode.decodeString("2", Json__Decode.map(Json__Decode.$$int, (function (i) {
                                return i + 1 | 0;
                              }))), {
                      TAG: /* Ok */0,
                      _0: 3
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should be able to map2", (function (t) {
                t.equal(Json__Decode.decodeString("{ \"a\": \"hi\", \"b\": 3 }", Json__Decode.map2(Json__Decode.field("a", Json__Decode.string), Json__Decode.field("b", Json__Decode.$$int), (function (a, b) {
                                return Math.imul(a.length, b);
                              }))), {
                      TAG: /* Ok */0,
                      _0: 6
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should be able to map3", (function (t) {
                t.equal(Json__Decode.decodeString("{ \"a\": \"hi\", \"b\": 3, \"c\": 3 }", Json__Decode.map3(Json__Decode.field("a", Json__Decode.string), Json__Decode.field("b", Json__Decode.$$int), Json__Decode.field("c", Json__Decode.$$int), (function (a, b, c) {
                                return Math.imul(a.length, b) + c | 0;
                              }))), {
                      TAG: /* Ok */0,
                      _0: 9
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode an nullable valid", (function (t) {
                t.equal(Json__Decode.decodeString("1", Json__Decode.nullable(Json__Decode.$$float)), {
                      TAG: /* Ok */0,
                      _0: 1
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should decode an nullable null", (function (t) {
                t.equal(Json__Decode.decodeString("null", Json__Decode.nullable(Json__Decode.$$float)), {
                      TAG: /* Ok */0,
                      _0: undefined
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should not decode an nullable invalid", (function (t) {
                Zora.resultError(t, Json__Decode.decodeString("a", Json__Decode.nullable(Json__Decode.$$float)), "Should be error");
                return Zora.done(undefined);
              }));
        t.test("should succeed", (function (t) {
                t.equal(Json__Decode.decodeString("\"value\"", Json__Decode.succeed(true)), {
                      TAG: /* Ok */0,
                      _0: true
                    }, "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should fail", (function (t) {
                Zora.resultError(t, Json__Decode.decodeString("\"value\"", Json__Decode.fail("bad")), "Should be error");
                return Zora.done(undefined);
              }));
        return Zora.done(undefined);
      }));

Zora$1.test("encode tests", (function (t) {
        t.test("should encode a string", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.string("value"), 0), "\"value\"", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode a int", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.$$int(1), 0), "1", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode a float", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.$$float(1), 0), "1", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode a bool", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.bool(true), 0), "true", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode a null", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.$$null, 0), "null", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode an empty array", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.array([], Json__Encode.$$int), 0), "[]", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode an array", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.array([
                              1,
                              2
                            ], Json__Encode.$$int), 0), "[1,2]", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode an empty list", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.list(/* [] */0, Json__Encode.$$int), 0), "[]", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode an list", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.list({
                              hd: 1,
                              tl: {
                                hd: 2,
                                tl: /* [] */0
                              }
                            }, Json__Encode.$$int), 0), "[1,2]", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode an empty object", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.object([]), 0), "{}", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode an object", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.object([[
                                "a",
                                Json__Encode.$$int(1)
                              ]]), 0), "{\"a\":1}", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode an empty dict", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.dict({}), 0), "{}", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode an dict", (function (t) {
                var d = {};
                d["a"] = Json__Encode.$$int(1);
                t.equal(Json__Encode.encode(Json__Encode.dict(d), 0), "{\"a\":1}", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode NaN to null", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.$$float(NaN), 0), "null", "Should equal");
                return Zora.done(undefined);
              }));
        t.test("should encode Infinity to null", (function (t) {
                t.equal(Json__Encode.encode(Json__Encode.$$float(Pervasives.infinity), 0), "null", "Should equal");
                return Zora.done(undefined);
              }));
        return Zora.done(undefined);
      }));

/*  Not a pure module */
