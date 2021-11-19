type value = Js.Json.t

type error 

type t<'a>

// primatives

let string: t<string> 

let bool: t<bool> 

let int: t<int> 

let float: t<float> 

// data structures

let nullable: t<'a> => t<option<'a>> 

let array: t<'a> => t<array<'a>> 

let list: t<'a> => t<list<'a>>

let dict: t<'a> => t<Js.Dict.t<'a>> 

let keyValuePairs: t<'a> => t<array<(string, 'a)>> 

// object primatives

let field: (string, t<'a>) => t<'a> 

let at: (string, array<string>, t<'a>) => t<'a> 

let index: (int, t<'a>) => t<'a> 

// inconsistent structure

let option: t<'a> => t<option<'a>> 

let oneOf: (t<'a>, array<t<'a>>) => t<'a> 

// run decoders

let decodeString: (t<'a>, string) => result<'a, error> 

let decodeValue: (t<'a>, value) => result<'a, error> 

let errorToString: error => string 

// combine

let map: (t<'a>, 'a => 'b) => t<'b> 

let map2: (t<'a>, t<'b>, ('a, 'b) => 'c) => t<'c> 

let map3: (t<'a>, t<'b>, t<'c>, ('a, 'b, 'c) => 'val) => t<'val> 

let map4: (t<'a>, t<'b>, t<'c>, t<'d>, ('a, 'b, 'c, 'd) => 'val) => t<'val> 

let map5: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, ('a, 'b, 'c, 'd, 'e) => 'val) => t<'val> 

let map6: (
  t<'a>,
  t<'b>,
  t<'c>,
  t<'d>,
  t<'e>,
  t<'f>,
  ('a, 'b, 'c, 'd, 'e, 'f) => 'val,
) => t<'val> 

let map7: (
  t<'a>,
  t<'b>,
  t<'c>,
  t<'d>,
  t<'e>,
  t<'f>,
  t<'g>,
  ('a, 'b, 'c, 'd, 'e, 'f, 'g) => 'val,
) => t<'val> 

let map8: (
  t<'a>,
  t<'b>,
  t<'c>,
  t<'d>,
  t<'e>,
  t<'f>,
  t<'g>,
  t<'h>,
  ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h) => 'val,
) => t<'val> 

let andMap: (t<'a => 'b>, t<'a>) => t<'b> 

// fancy

let null: 'a => t<'a> 

let value: t<value> 

let andThen: (t<'a>, 'a => t<'b>) => t<'b> 

let succeed: 'a => t<'a> 

let fail: string => t<'a> 

