---
slug: /
sidebar_position: 1
---

# Intro

This package helps you convert between Rescript values and JSON values.
It's usually used alongside http requests to talk to servers or with [external](https://rescript-lang.org/docs/manual/latest/external) calls that talk to JavaScript.

## Install

In your projects root directory, run:
```cli
yarn add rescript-json
```

Then update `bsconfig.js` to include this package as a dependency:
```json
{
  ...,
  "bs-dependencies": [..., "rescript-json"]
}
```

## An Example

> This example is taken directly from [Elm's JSON decoding library](https://package.elm-lang.org/packages/elm/json/latest/.) 

Have you seen this [causes of death](https://en.wikipedia.org/wiki/List_of_causes_of_death_by_rate) table? Did you know that in 2002, war accounted for 0.3% of global deaths whereas road traffic accidents accounted for 2.09% and diarrhea accounted for 3.15%?

The table is interesting, but say we want to visualize this data in a nicer way. We will need some way to get the cause-of-death data from our server, so we create encoders and decoders:

```rescript
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
      ("name", string(cause.name)),
      ("percent", float(cause.percent)),
      ("percentPer100K", float(cause.percentPer100K)),
    ])
  }

  let decoder: Json.Decode.t<t> = {
    open Json.Decode
    map3(
      field("name", string),
      field("percent", float(percent),
      field("percentPer100K", float(percentPer100K),
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
```

Now in some other code we can use Cause.encode and Cause.decoder as building blocks. So if we want to decode a array of causes, saying `Json.Decode.array(Cause.decoder)` will handle it!

Point is, the goal should be:

- Make small JSON decoders and encoders.
- Snap together these building blocks as needed.

So say you decide to make the name field more precise. Instead of a `string`, you want to use codes from the [International Classification of Diseases](https://www.who.int/classifications/classification-of-diseases) of recommended by the World Health Organization. These [codes](https://icd.who.int/browse10/2016/en) are used in a lot of mortality data sets. So it may make sense to make a separate `icdCode` module with its own `IcdCode.encode` and `IcdCode.decoder` that ensure you are working with valid codes. From there, you can use them as building blocks in the `Cause` module!

## Another Example

At the beginning, lots of folks have trouble using the style of JSON decoding presented in the library.
It's somewhat different from other JSON decoders because it encourages you to structure your Rescript types differently from JSON structure.

For example, say you have the JSON:
```json
{
  "people": [
    {
      "name": "Maria",
      "age": 25,
      "pet": { "type": "cat", "name": "Paul"}
    },
    {
      "name": "Carlos",
      "age": 22,
      "pet": { "type": "dog", "name": "Ringo"}
    }
  ]
}
```

**And say that the only data we need from this JSON the `name` of each person and the `type` of pet they have.**

In another popular Reason/Rescript decoding library called [decco](https://github.com/reasonml-labs/decco), you'd setup your decoders like:
```rescript
@decco
type pet = {
  [@decco.key "type"]
  type_: string
}

@decco
type person = {
  name: string,
  pet: pet
}

@decco
type doc = {
  people: array<person>
}
```

At 1st glance, this might seem perfectly reasonable.
But really, you should only need 1 type to model the data you need.
In fact, ideally we could model just the data we need with:

```rescript
type person2 = { name: string, type_: string }
```

This would be totally possible to get using `decco`, you'd just have to map over the `people` array, then convert each `person` to `person2`.

However, in `rescript-json`, you could directly define your encoder to convert the raw JSON directly into `person2`:

```rescript
module D = Json.Decoder

let person2Decoder: D.t<person2> =
  D.map2(
    D.field("name", D.string),
    D.at(["pet", "type"], D.string),
    ~f=(name, type_) => {name: name, type_: type_}
  )

let docDecoder: D.t<array<person2>> =
  D.field("people", D.array(person2Decoder))
```

In this example, we're picking off the specific fields we're decoding and creating a nicer-to-use Rescript type. 
This decouples our Rescript code from the format the JSON comes in and makes working these types much nicer!


## Credit

This package is a port of [Elm's JSON decoding library](https://package.elm-lang.org/packages/elm/json/latest/).

When creating this package, I basically went through the docs for the Elm library and implemented a Rescript version. Additional, because it's so well done, lots of documentation here is copied almost verbatim from the Elm package.

Thanks to Evan Czaplicki ([@evancz](https://github.com/evancz)) and all other folks for designing and creating the excellent Elm package!

