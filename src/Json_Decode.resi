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

let tuple2: (t<'a>, t<'b>) => t<('a, 'b)>

let tuple3: (t<'a>, t<'b>, t<'c>) => t<('a, 'b, 'c)>

let tuple4: (t<'a>, t<'b>, t<'c>, t<'d>) => t<('a, 'b, 'c, 'd)>

let tuple5: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>) => t<('a, 'b, 'c, 'd, 'e)>

let tuple6: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, t<'f>) => t<('a, 'b, 'c, 'd, 'e, 'f)>

let tuple7: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, t<'f>, t<'g>) => t<('a, 'b, 'c, 'd, 'e, 'f, 'g)>

let tuple8: (t<'a>, t<'b>, t<'c>, t<'d>, t<'e>, t<'f>, t<'g>, t<'h>) => t<('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h)>

// object primatives

let field: (string, t<'a>) => t<'a> 

let at: (string, array<string>, t<'a>) => t<'a> 

let index: (int, t<'a>) => t<'a> 

// inconsistent structure

let option: t<'a> => t<option<'a>> 

let oneOf: (t<'a>, array<t<'a>>) => t<'a> 

// run decoders

let decodeString: (string, t<'a>) => result<'a, error> 

let decodeValue: (value, t<'a>) => result<'a, error> 

let errorToString: error => string 

// combine

let map: (t<'a>, ~f: 'a => 'b) => t<'b> 

let map2: (t<'a>, t<'b>, ~f: ('a, 'b) => 'c) => t<'c> 

let map3: (t<'a>, t<'b>, t<'c>, ~f: ('a, 'b, 'c) => 'val) => t<'val> 

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

let andMap: (t<'a => 'b>, t<'a>) => t<'b> 

// fancy

let null: 'a => t<'a> 

let value: t<value> 

let andThen: (t<'a>, ~f: 'a => t<'b>) => t<'b> 

let succeed: 'a => t<'a> 

let fail: string => t<'a> 

