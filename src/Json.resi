@@ocaml.text("{1 JSON in Rescript}")
@@ocaml.text("
This package helps you convert between Rescript values and JSON values.

This package is usually used alongside http requests to talk to servers or with {{:https://rescript-lang.org/docs/manual/latest/external} external} calls talk to JavaScript.
")

@@ocaml.text("{2 Install}")

@@ocaml.text("
In your projects root directory, run:
{[
  yarn add rescript-json
]}

Then update `bsconfig.js` to include this package as a dependency:
{[
  {
    ...,
    \"bs-dependencies\": [..., \"rescript-json\"]
  }
]}
")

@@ocaml.text("{2 Example}")

@@ocaml.text("
Have you seen this {{: https://en.wikipedia.org/wiki/List_of_causes_of_death_by_rate} causes of death} table? Did you know that in 2002, war accounted for 0.3% of global deaths whereas road traffic accidents accounted for 2.09% and diarrhea accounted for 3.15%?

The table is interesting, but say we want to visualize this data in a nicer way. We will need some way to get the cause-of-death data from our server, so we create encoders and decoders:

{[
  module Cause = {
    type t =
      {
        name: string,
        percent: float,
        percentPer100K: float,
      }

    let encode = (cause: t): Json.value => {
      open Json.Encode
      object([
        (\"name\", string(cause.name)),
        (\"percent\", float(cause.percent)),
        (\"percentPer100K\", float(cause.percentPer100K)),
      ])
    }

    let decoder: Json.Decode.t<t> = {
      open Json.Decode
      map3(
        field(\"name\", string),
        field(\"percent\", float(percent),
        field(\"percentPer100K\", float(percentPer100K),
        ~f=(name, percent, percentPer100K) =>
          {
            name: name,
            percent: percent,
            percentPer100K: percentPer100K
          }
        )
      )
    }
  }
]}

Now in some other code we can use Cause.encode and Cause.decoder as building blocks. So if we want to decode a list of causes, saying [Json.Decode.array(Cause.decoder)] will handle it!

Point is, the goal should be:

{ol {- Make small JSON decoders and encoders.}
    {- Snap together these building blocks as needed.}
}

So say you decide to make the name field more precise. Instead of a [string], you want to use codes from the {{: https://www.who.int/classifications/classification-of-diseases} International Classification of Diseases} recommended by the World Health Organization. These {{: https://icd.who.int/browse10/2016/en} codes} are used in a lot of mortality data sets. So it may make sense to make a separate [icdCode] module with its own [IcdCode.encode] and [IcdCode.decoder] that ensure you are working with valid codes. From there, you can use them as building blocks in the [Cause] module!
")

@@ocaml.text("{2 Docs}")

type value = Js.Json.t
@@ocaml.text("Represents a JavaScript value.")

module Decode = Json__Decode
@@ocaml.text("The Decode module. Accessed by [Json.Decode.*]")

module Encode = Json__Encode
@@ocaml.text("The Encode module. Accessed by [Json.Encode.*]")

@@ocaml.text("{2 Credit}")
@@ocaml.text("
This package is a port of {{: https://package.elm-lang.org/packages/elm/json/latest/} Elm's JSON decoding library}.

When creating this package, I basically went through the docs for the Elm library and implemented a Rescript version. Additional, because it's so well done, the documentation is copied almost verbatim.

Thanks to Evan Czaplicki ({{: https://github.com/evancz} \@evancz}) and all other folks for designing and creating the excellent Elm package!
")
