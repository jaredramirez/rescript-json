@@ocaml.text("Represents a JavaScript value.")
type value = Js.Json.t

@@ocaml.text("The Decode module. Accessed by [Json.Decode.*]")
module Decode = Json__Decode

@@ocaml.text("The Encode module. Accessed by [Json.Encode.*]")
module Encode = Json__Encode
