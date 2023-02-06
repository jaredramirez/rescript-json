"use strict";(self.webpackChunkrescript_json=self.webpackChunkrescript_json||[]).push([[671],{3905:(e,t,n)=>{n.d(t,{Zo:()=>c,kt:()=>h});var a=n(7294);function r(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function o(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);t&&(a=a.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,a)}return n}function l(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?o(Object(n),!0).forEach((function(t){r(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):o(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function s(e,t){if(null==e)return{};var n,a,r=function(e,t){if(null==e)return{};var n,a,r={},o=Object.keys(e);for(a=0;a<o.length;a++)n=o[a],t.indexOf(n)>=0||(r[n]=e[n]);return r}(e,t);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(a=0;a<o.length;a++)n=o[a],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(r[n]=e[n])}return r}var i=a.createContext({}),p=function(e){var t=a.useContext(i),n=t;return e&&(n="function"==typeof e?e(t):l(l({},t),e)),n},c=function(e){var t=p(e.components);return a.createElement(i.Provider,{value:t},e.children)},d="mdxType",u={inlineCode:"code",wrapper:function(e){var t=e.children;return a.createElement(a.Fragment,{},t)}},m=a.forwardRef((function(e,t){var n=e.components,r=e.mdxType,o=e.originalType,i=e.parentName,c=s(e,["components","mdxType","originalType","parentName"]),d=p(n),m=r,h=d["".concat(i,".").concat(m)]||d[m]||u[m]||o;return n?a.createElement(h,l(l({ref:t},c),{},{components:n})):a.createElement(h,l({ref:t},c))}));function h(e,t){var n=arguments,r=t&&t.mdxType;if("string"==typeof e||r){var o=n.length,l=new Array(o);l[0]=m;var s={};for(var i in t)hasOwnProperty.call(t,i)&&(s[i]=t[i]);s.originalType=e,s[d]="string"==typeof e?e:r,l[1]=s;for(var p=2;p<o;p++)l[p]=n[p];return a.createElement.apply(null,l)}return a.createElement.apply(null,n)}m.displayName="MDXCreateElement"},9881:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>i,contentTitle:()=>l,default:()=>u,frontMatter:()=>o,metadata:()=>s,toc:()=>p});var a=n(7462),r=(n(7294),n(3905));const o={slug:"/",sidebar_position:1},l="Intro",s={unversionedId:"intro",id:"intro",title:"Intro",description:"This package helps you convert between Rescript values and JSON values.",source:"@site/docs/intro.md",sourceDirName:".",slug:"/",permalink:"/",draft:!1,editUrl:"https://github.com/jaredramirez/rescript-json/tree/main/docs/intro.md",tags:[],version:"current",sidebarPosition:1,frontMatter:{slug:"/",sidebar_position:1},sidebar:"tutorialSidebar",next:{title:"Modules",permalink:"/category/modules"}},i={},p=[{value:"Install",id:"install",level:2},{value:"An Example",id:"an-example",level:2},{value:"Another Example",id:"another-example",level:2},{value:"Credit",id:"credit",level:2}],c={toc:p},d="wrapper";function u(e){let{components:t,...n}=e;return(0,r.kt)(d,(0,a.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"intro"},"Intro"),(0,r.kt)("p",null,"This package helps you convert between Rescript values and JSON values.\nIt's usually used alongside http requests to talk to servers or with ",(0,r.kt)("a",{parentName:"p",href:"https://rescript-lang.org/docs/manual/latest/external"},"external")," calls that talk to JavaScript."),(0,r.kt)("h2",{id:"install"},"Install"),(0,r.kt)("p",null,"In your projects root directory, run:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-cli"},"yarn add rescript-json\n")),(0,r.kt)("p",null,"Then update ",(0,r.kt)("inlineCode",{parentName:"p"},"bsconfig.js")," to include this package as a dependency:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-json"},'{\n  ...,\n  "bs-dependencies": [..., "rescript-json"]\n}\n')),(0,r.kt)("h2",{id:"an-example"},"An Example"),(0,r.kt)("blockquote",null,(0,r.kt)("p",{parentName:"blockquote"},"This example is taken directly from ",(0,r.kt)("a",{parentName:"p",href:"https://package.elm-lang.org/packages/elm/json/latest/."},"Elm's JSON decoding library")," ")),(0,r.kt)("p",null,"Have you seen this ",(0,r.kt)("a",{parentName:"p",href:"https://en.wikipedia.org/wiki/List_of_causes_of_death_by_rate"},"causes of death")," table? Did you know that in 2002, war accounted for 0.3% of global deaths whereas road traffic accidents accounted for 2.09% and diarrhea accounted for 3.15%?"),(0,r.kt)("p",null,"The table is interesting, but say we want to visualize this data in a nicer way. We will need some way to get the cause-of-death data from our server, so we create encoders and decoders:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-rescript"},'module Cause = {\n  type t =\n    {\n      name: string,\n      percent: float,\n      percentPer100K: float,\n    }\n\n  let encode = (cause: t): Json.value => {\n    open Json.Encode\n    object([\n      ("name", string(cause.name)),\n      ("percent", float(cause.percent)),\n      ("percentPer100K", float(cause.percentPer100K)),\n    ])\n  }\n\n  let decoder: Json.Decode.t<t> = {\n    open Json.Decode\n    map3(\n      field("name", string),\n      field("percent", float(percent),\n      field("percentPer100K", float(percentPer100K),\n      ~f=(name, percent, percentPer100K) =>\n        {\n          name: name,\n          percent: percent,\n          percentPer100K: percentPer100K\n        }\n      )\n    )\n  }\n}\n')),(0,r.kt)("p",null,"Now in some other code we can use Cause.encode and Cause.decoder as building blocks. So if we want to decode a array of causes, saying ",(0,r.kt)("inlineCode",{parentName:"p"},"Json.Decode.array(Cause.decoder)")," will handle it!"),(0,r.kt)("p",null,"Point is, the goal should be:"),(0,r.kt)("ul",null,(0,r.kt)("li",{parentName:"ul"},"Make small JSON decoders and encoders."),(0,r.kt)("li",{parentName:"ul"},"Snap together these building blocks as needed.")),(0,r.kt)("p",null,"So say you decide to make the name field more precise. Instead of a ",(0,r.kt)("inlineCode",{parentName:"p"},"string"),", you want to use codes from the ",(0,r.kt)("a",{parentName:"p",href:"https://www.who.int/classifications/classification-of-diseases"},"International Classification of Diseases")," of recommended by the World Health Organization. These ",(0,r.kt)("a",{parentName:"p",href:"https://icd.who.int/browse10/2016/en"},"codes")," are used in a lot of mortality data sets. So it may make sense to make a separate ",(0,r.kt)("inlineCode",{parentName:"p"},"icdCode")," module with its own ",(0,r.kt)("inlineCode",{parentName:"p"},"IcdCode.encode")," and ",(0,r.kt)("inlineCode",{parentName:"p"},"IcdCode.decoder")," that ensure you are working with valid codes. From there, you can use them as building blocks in the ",(0,r.kt)("inlineCode",{parentName:"p"},"Cause")," module!"),(0,r.kt)("h2",{id:"another-example"},"Another Example"),(0,r.kt)("p",null,"At the beginning, lots of folks have trouble using the style of JSON decoding presented in the library.\nIt's somewhat different from other JSON decoders because it encourages you to structure your Rescript types differently from JSON structure."),(0,r.kt)("p",null,"For example, say you have the JSON:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-json"},'{\n  "people": [\n    {\n      "name": "Maria",\n      "age": 25,\n      "pet": { "type": "cat", "name": "Paul"}\n    },\n    {\n      "name": "Carlos",\n      "age": 22,\n      "pet": { "type": "dog", "name": "Ringo"}\n    }\n  ]\n}\n')),(0,r.kt)("p",null,(0,r.kt)("strong",{parentName:"p"},"And say that the only data we need from this JSON the ",(0,r.kt)("inlineCode",{parentName:"strong"},"name")," of each person and the ",(0,r.kt)("inlineCode",{parentName:"strong"},"type")," of pet they have.")),(0,r.kt)("p",null,"In another popular Reason/Rescript decoding library called ",(0,r.kt)("a",{parentName:"p",href:"https://github.com/reasonml-labs/decco"},"decco"),", you'd setup your decoders like:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-rescript"},'@decco\ntype pet = {\n  [@decco.key "type"]\n  type_: string\n}\n\n@decco\ntype person = {\n  name: string,\n  pet: pet\n}\n\n@decco\ntype doc = {\n  people: array<person>\n}\n')),(0,r.kt)("p",null,"At 1st glance, this might seem perfectly reasonable.\nBut really, you should only need 1 type to model the data you need.\nIn fact, ideally we could model just the data we need with:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-rescript"},"type person2 = { name: string, type_: string }\n")),(0,r.kt)("p",null,"This would be totally possible to get using ",(0,r.kt)("inlineCode",{parentName:"p"},"decco"),", you'd just have to map over the ",(0,r.kt)("inlineCode",{parentName:"p"},"people")," array, then convert each ",(0,r.kt)("inlineCode",{parentName:"p"},"person")," to ",(0,r.kt)("inlineCode",{parentName:"p"},"person2"),"."),(0,r.kt)("p",null,"However, in ",(0,r.kt)("inlineCode",{parentName:"p"},"rescript-json"),", you could directly define your encoder to convert the raw JSON directly into ",(0,r.kt)("inlineCode",{parentName:"p"},"person2"),":"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-rescript"},'module D = Json.Decoder\n\nlet person2Decoder: D.t<person2> =\n  D.map2(\n    D.field("name", D.string),\n    D.at(["pet", "type"], D.string),\n    ~f=(name, type_) => {name: name, type_: type_}\n  )\n\nlet docDecoder: D.t<array<person2>> =\n  D.field("people", D.array(person2Decoder))\n')),(0,r.kt)("p",null,"In this example, we're picking off the specific fields we're decoding and creating a nicer-to-use Rescript type.\nThis decouples our Rescript code from the format the JSON comes in and makes working these types much nicer!"),(0,r.kt)("h2",{id:"credit"},"Credit"),(0,r.kt)("p",null,"This package is a port of ",(0,r.kt)("a",{parentName:"p",href:"https://package.elm-lang.org/packages/elm/json/latest/"},"Elm's JSON decoding library"),"."),(0,r.kt)("p",null,"When creating this package, I basically went through the docs for the Elm library and implemented a Rescript version. Additional, because it's so well done, lots of documentation here is copied almost verbatim from the Elm package."),(0,r.kt)("p",null,"Thanks to Evan Czaplicki (",(0,r.kt)("a",{parentName:"p",href:"https://github.com/evancz"},"@evancz"),") and all other folks for designing and creating the excellent Elm package!"))}u.isMDXComponent=!0}}]);