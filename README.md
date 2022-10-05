## rescript-json

This package helps you convert between Rescript values and JSON values.

This package is usually used alongside http requests to talk to servers or with [external](https://rescript-lang.org/docs/manual/latest/external) calls talk to JavaScript.

### Install

In your projects root directory, run:
```
yarn add rescript-json
```

Then update `bsconfig.js` to include this package as a dependency:
```
{
  ...,
  "bs-dependencies": [..., "rescript-json"]
}
```

### API Docs

The docs are [here](https://jaredramirez.github.io/rescript-json/gen/RescriptJson/Json/)!

### Credit

This package is a port of [Elm's JSON decoding library](https://package.elm-lang.org/packages/elm/json/latest/).

When creating this package, I basically went through the docs for the Elm library and implemented a Rescript version. Additional, because it's so well done, the documentation is copied verbatim.

Thanks to Evan Czaplicki ([@evancz](https://github.com/evancz)) and all other folks for designing and creating the excellent Elm package!

### Changelog

#### 1.0.3

- Rescript 10
