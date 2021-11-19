module J = Js.Json
module B = Belt

type value = J.t

let toString: value => string = J.stringify
