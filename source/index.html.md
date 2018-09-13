---
title: React Localize Redux Documentation

language_tabs: # must be one of https://git.io/vQNgJ

toc_footers:
  - <a href='https://github.com/ryandrewjohnson/react-localize-redux'>Project on Github</a>

search: true
---

# Getting Started

> Install:

```shell
npm install react-localize-redux --save
```

Once you have finished installation you're ready to get going. The **Getting Started** guide is a place to great start,
but I also recommend you take some time to familiarize yourself with the rest of the documentation.

Also `react-localize-redux` is built on React's native [Context](https://reactjs.org/docs/context.html), and although it's not necessary, it doesn't hurt
to familirize yourself with it as well.

🎉 **Happy Localizing!** 🎉

## Add LocalizeProvider

> Wrap your app with `<LocalizeProvider />`

```jsx
import React from "react";
import { render } from "react-dom";
import { BrowserRouter as Router, Route } from "react-router-dom";
import { LocalizeProvider } from "react-localize-redux";
import Main from "./Main";

const App = props => (
  <LocalizeProvider>
    <Router>
      <Route path="/" component={Main} />
    </Router>
  </LocalizeProvider>
);

render(<App />, document.getElementById("root"));
```

By wrapping your application with `<LocalizeProvider />` all component's in the hierarchy below
will have the ability to work with localize.

<aside class="success">
<strong>Using Redux?</strong> — if you wish to store your translations in redux then all you need to do
is pass the redux <code>store</code> to <code>LocalizeProvider</code>. See <a href="#what-if-i-want-to-use-redux">What if I want to use Redux?</a> for more details.
</aside>

## Initialize localize

```jsx
import React from "react";
import { renderToStaticMarkup } from "react-dom/server";
import { withLocalize } from "react-localize-redux";
import globalTranslations from "./translations/global.json";

class Main extends React.Component {
  constructor(props) {
    super(props);

    this.props.initialize({
      languages: [
        { name: "English", code: "en" },
        { name: "French", code: "fr" }
      ],
      translation: globalTranslations,
      options: { renderToStaticMarkup }
    });
  }

  render() {
    // render Main layout component
  }
}

export default withLocalize(Main);
```

Before accessing any translations in your app you will need to [initialize](#initialize) localize with your settings.
The settings object requires `lanuages`, while `translation`, and `options` are optional.

| Property    | Type   | Description                                                                                                        |
| ----------- | ------ | ------------------------------------------------------------------------------------------------------------------ |
| languages   | array  | An array of languages your translations will support.                                                              |
| translation | object | Translation data in [all languages](#all-languages-format) or [single language](#single-language-format) format. |
| options     | object | See [initialize options](#initialize).                                                                            |

<aside class="success">
<a href="#why-do-i-need-to-pass-rendertostaticmarkup-to-initialize">Why do I need to pass <code>renderToStaticMarkup</code> to initialize?</a>
</aside>

<aside class="notice">
For your component to have access to the <code>initialize</code> prop you'll need to use the <code><a href="#withlocalize">withLocalize</a></code> higher-order component.
</aside>

## Add translation data

> To add multi language translations, use `addTranslation`:

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";
import movieTranslations from "./translations/movies.json";

class Movies extends React.Component {
  constructor(props) {
    super(props);

    this.props.addTranslation(movieTranslations);
  }

  render() {
    // render movie component
  }
}

export default withLocalize(Movies);
```

> To add single language translations, use `addTranslationForLanguage`:

```jsx
import frenchMovieTranslations from "./translations/fr.movies.json";

this.props.addTranslationForLanguage(frenchMovieTranslations, "fr");
```

Translation data comes in two different flavours - the [all languages](#all-languages-format) and [single language](#single-language-format) format.

* Use [addTranslation](#addtranslation) method to add data in `all languges` format.
* Use [addTranslationForLanguage](#addtranslationforlanguage) method to add data in `single languge` format.

As soon as you add the translation data to localize it can be rendered in your components using [Translate](#translate-2).

<aside class="notice">
For your component to have access to the <code>addTranslation</code> and <code>addTranslationForLanguage</code> props you'll need to use the <code><a href="#withlocalize">withLocalize</a></code> higher-order component.
</aside>

## Add translations to components

> Assuming the following translations have been added:

```json
{
  "movie": {
    "title": ["Jurassic Park", "Le Parc jurassique"]
  }
}
```

Once you've added your translation data you'll need a way to get it into your components. That is where the [Translate](#translate-2) component comes in, and it can be used in a variety of ways. The `id` prop passed to `Translate` should match the id of the translation data you want to insert

### Translate with default translations:

> With default language:

```jsx
import React from "react";
import { Translate } from "react-localize-redux";

const Movies = props => (
  <h1>
    <Translate id="movie.title">Jurassic Park</Translate>
  </h1>
);
```

You can include your default language's translation with `Translate` by passing it as children to the component. The translation will automatically
be added to your translation data for that `id`' and default language.

### Translate with self-closing tag

> With self-closing tag:

```jsx
const Movies = props => (
  <h1>
    <Translate id="movie.title" />
  </h1>
);
```

If you don't wish to include default translations then all you need provide is a translation `id` prop, and no `children`.

### Translate with Render props

> With render props:

```jsx
const Movies = props => (
  <Translate>
    {({ translate }) => <h1>{translate("movie.title")}</h1>}
  </Translate>
);
```

You can also pass Translate a function as it's child that returns the elements you want to render. This function is commonly referred to as a [render prop function](https://reactjs.org/docs/render-props.html), and is passed a single object with props [Translate](#translate-2), [activeLanguage](#activelanguage), and [languages](#languages).

## Change active language

> Language selector using `setActiveLanguage`:

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";

const LanguageToggle = ({ languages, activeLanguage, setActiveLanguage }) => (
  <ul className="selector">
    {languages.map(lang => (
      <li key={lang.code}>
        <button onClick={() => setActiveLanguage(lang.code)}>
          {lang.name}
        </button>
      </li>
    ))}
  </ul>
);

export default withLocalize(LanguageToggle);
```

Use the [setActiveLanguage](#setactivelanguage) method to change localize's active language.

<aside class="notice">
For your component to have access to the <code>setActiveLanguage</code> prop you'll need to use the <code><a href="#withlocalize">withLocalize</a></code> higher-order component.
</aside>

# Formatting Translations

Translation data can be stored in either json or vanilla JS, but more importantly in order for `localize` to work with
your data it will need to be in one of the following formats.

## All languages format

> translations.json

```javascript
{
  "greeting": [
    "Hello",      (en)
    "Bonjour",    (fr)
  ],
  "farewell": [
    "Goodbye",    (en)
    "Au revoir",  (fr)
  ]
}
```

**Use this format when you want to store translations for all languages in the same file.**

Translation data will be an object where the property name is your translation id, and the value is an array of translations. The translation id must be unique across **all** your translations, and the value is an array that enforces the following rules:

* Includes a translation for each language your app supports.
* The order of the translation strings in the array matters! The order **MUST** follow the order of the languages array passed to [initialize](#initialize).

<aside class="notice">
The <a href="#addtranslation"><code>addTranslation</code></a> action requires translations in this format.
</aside>

## Single language format

> en.translations.json

```javascript
{
  "greeting": "Hello",
  "farewell": "Goodbye"
}
```

> fr.translations.json

```javascript
{
  "greeting":"Bonjour",
  "farewell": "Au revoir"
}
```

**Use this format when you want to have a translation file for each separate language.**

Translation data will be an object where the property name is your translation id, and the value is the translation for the language. The translation id must be unique across **all** your translations.

<aside class="notice">
The <a href="#addtranslationforlanguage"><code>addTranslationForLanguage</code></a> action requires translations in this format.
</aside>

## Nested format

> Multiple language format

```javascript
{
  "welcome" {
    "greeting": ["Hello", "Bonjour", "Hola"],
    "farewell": ["Goodbye", "Au revoir", "Adiós"]
  }
}
```

> Single language format

```javascript
// en.json
{
  "welcome" {
    "greeting": "Hello"
    "farewell": "Goodbye"
  }
}
// fr.json
{
  "welcome" {
    "greeting": "Bonjour"
    "farewell": "Au revoir"
  }
}
```

> Use dot syntax for translation id

```jsx
import React from "react";
import { Translate } from "react-localize-redux";

const Greeting = props => (
  <div>
    <Translate id="welcome.greeting">Hello</Translate>
    <Translate id="welcome.farewell">Goodbye</Translate>
  </div>
);
```

Both types of translation data formats support nesting to help with organization of translations, and avoid naming collisions with translation ids.

## Custom format

See [Custom translation format](#custom-translation-format) for details.

# Guides

## Include inline default translations

> Pass default language translations to `Translate`

```jsx
import React from "react";
import { Translate } from "react-localize-redux";

const Greeting = props => (
  <div>
    <Translate id="greeting">Hello</Translate>
    <Translate id="farewell">Bye Bye</Translate>

    <Translate id="congrats" options={{ ignoreTranslateChildren: true }}>
      Way to go!
    </Translate>
  </div>
);
```

> Translations `before` and `after` Translate

```javascript
// translation data before defaults are provided
{
  greeting: [null, 'Bonjour'],
  farewell: ['Goodbye', 'Au Revoir'],
  congrats: ['Congratulations', 'Toutes nos félicitations']
}

// translation data after defaults are passed with Translate
{
  greeting: ['Hello', 'Bonjour'],
  farewell: ['Bye Bye', 'Au Revoir'],
  congrats: ['Congratulations', 'Toutes nos félicitations']
}
```

With [Translate](#translate-2) you can include an inline translation for the default language by passing
as `children` to the component.

When you pass an inline translation to `Translate` it will be added to your translation data under the corresponding `id`
for the default language. If the default language's translation for that `id` already exists it will be overriden
with the inline translation.

If you don't want existing translation data overriden you can set `Translate`'s [ignoreTranslateChildren](#translate-2) option to `true`.
When set to `true` the existing translation data will always be rendered, and the inline translation will be ignored.

## Dynamic translations

> Translations with placeholders

```javascript
{
  greeting: "Hello, ${name}!",
  today: "Today is ${date}"
}
```

> Using data attribute

```jsx
import React from "react";
import { Translate } from "react-localize-redux";

const Greeting = props => (
  <Translate id="greeting" data={{ name: "Testy McTest" }}>
    {"Hello ${ name }"}
  </Translate>
);
```

> Using render props

```jsx
import React from "react";
import { Translate } from "react-localize-redux";

const Today = props => (
  <Translate>
    {({ translate }) => <h1>{translate("today", { date: Date.now() })}</h1>}
  </Translate>
);
```

You can add dynamic content to your translations by inserting placeholders with the following format `${placeholder}`.
Then using the [Translate](#translate-2) component you will be able to pass in data that will inserted for each corresponding placeholder.

## HTML translations

> Translation with HTML

```json
{
  "google-link": [
    "<a href='https://www.google.en/'>Google</a>",
    "<a href='https://www.google.fr/'>Google</a>"
  ]
}
```

> Override renderInnerHtml option for translation

```jsx
import React from "react";
import { Translate } from "react-localize-redux";

const Link = props => (
  <Translate id="google-link" options={{ renderInnerHtml: false }} />
);

// with render props
const Link = props => (
  <Translate>
    {({ translate }) => (
      <p>{translate("google-link", null, { renderInnerHtml: false })}</p>
    )}
  </Translate>
);
```

As long as you've set the [initialize](#initialize) option [renderInnerHtml](#initialize) to `true` any HTML markup in your translations
will be rendered when using [Translate](#translate-2).

In addition to setting `renderInnerHtml` globally you can also override it for a specific translation's by passing an
[options](#translate-2) prop to `Translate`.

## React translations

> Translations with placeholders

```javascript
{
  link: "Click ${ nav }!",
  here: "here"
}
```

> Using data attribute

```jsx
import React from "react";
import { Translate } from "react-localize-redux";
import { Link } from "react-router-dom";

const LinkWithText = () => (
  <Link to="/">
    <Translate id="here" />
  </Link>
);

const MyLink = props => (
  <Translate id="link" data={{ nav: <LinkWithText /> }}>
    {"Click ${ nav }"}
  </Translate>
);
```

You can also pass React components as dynamic content. The example demonstrates how to insert a `Link` from `react-router` into a translated string.

**Note**: This feature is not currently supported for React Native. It is also not compatible with translations that have
HTML. i.e. You cannot pass a React component to a string like `"<strong>Hello</strong> ${ name }"`

## Handle missing translations

> Return translation for default language in place of missing translation

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";

const onMissingTranslation = ({ defaultTranslation }) => defaultTranslation;

class Missing extends React.Component {
  constructor(props) {
    super(props);

    this.props.initialize({
      languages: ["en", "fr"],
      options: { onMissingTranslation }
    });
  }
}

export default withLocalize(Missing);
```

> Override onMissingTranslation for specific translation

```jsx
import React from "react";
import { Translate } from "react-localize-redux";

const onMissingTranslation = ({ translationId, languageCode }) => {
  return `Nada for ${translationId} - ${languageCode}`;
};

const Missing = props => (
  <Translate id="missing" options={{ onMissingTranslation }} />
);
```

By default when a translation isn't found the following message will be rendered in it's place:

**`Missing translationId: ${ translationId } for language: ${ languageCode }`**

<br/>

**Adding custom missing translation logic**

This can be overidden at a global level by providing the [onMissingTranslation](#initialize) option to [initialize](#initialize).
You'll need to pass `onMissingTranslation` a function for it's value, and that function should return
a string that will be rendered in the missing translation's place.

The `onMissingTranslation` function will receive a single argument - an object with the following properties:

| Property           | Type   | Description                                             |
| ------------------ | ------ | ------------------------------------------------------- |
| translationId      | string | The id for the missing translation                      |
| languageCode       | string | The languageCode for the language being retrieved       |
| defaultTranslation | string | The translation for the default language - _if defined_ |

## Retrieving multiple translations

> Given following translations

```javascript
{
  greeting: "Hello, ${name}!",
  today: "Today is ${date}"
}
```

> Use the spread operator to pass the translations as props

```jsx
import React from "react";
import { Translate } from "react-localize-redux";

const Article = props => (
  <div>
    <h2>{props["greeting"]}</h2>
    <p>{props["today"]}</p>
  </div>
);

const Page = ({ translate }) => (
  <Translate>
    {{ translate }} =>
    <Article
      {...translate(["greeting", "today"], { name: "Ted", date: Date.now() })}
    />
    }
  </Translate>
);
```

To retrieve multiple translations using [Translate](#translate-2) pass an array of translation ids instead of a single id. This will return an object with translated strings mapped to translation ids.

## Custom translation format

> Unsupported translation format

```javascript
const customTranslation = {
  en: {
    greeting: "Hello",
    farewell: "Goodbye"
  },
  fr: {
    greeting: "Bonjour",
    farewell: "Au Revoir"
  }
};
```

> Transformation function must return data in [all languages format]()

```javascript
{
  greeting: ['Hello', 'Bonjour'],
  farewell: ['Goodbye', 'Au Revoir']
}
```

> Pass the transformFunction to addTranslation:

```javascript
import React from "react";
import { withLocalize } from "react-localize-redux";

const transformFunction = (
  translationData: Object,
  languagesCodes: string[]
) => {
  // Your transformation logic goes here...
};

class CustomStuff extends React.Component {
  constructor(props) {
    super(props);

    this.props.addTranslation(customTranslation, {
      translationTransform: transformFunction
    });
  }
}

export default withLocalize(CustomStuff);
```

Do you have legacy translation data that doesn't fit one of localize's [supported formats](#formatting-translations)? In this case you can try [addTranslation](#addtranslation)'s
[translationTransform](#addtranslation) option, which can be passed when adding translations.

The `translationTransform` option takes a function that is responsible for transforming your custom translation data into localize's supported [all languages format](#all-languages-format).

The translation function will be passed the below arguments, and should return data in `all languages format`:

| Parameter       | Type     | Description                                                       |
| --------------- | -------- | ----------------------------------------------------------------- |
| translationData | Object   | The custom translation data before transformation                 |
| languagesCodes  | string[] | An array of languageCodes based on languages passed to initialize |

# FAQ

## What if I want to use Redux?

> Redux usage:

```jsx
import React from "react";
import { render } from "react-dom";
import { createStore, combineReducers } from "redux";
import { Provider } from "react-redux";
import { LocalizeProvider, localizeReducer } from "react-localize-redux";
import { composeWithDevTools } from "redux-devtools-extension";

import Main from "./Main";

const rootReducer = combineReducers({
  localize: localizeReducer,
  // other reducers
});

const store = createStore(
  rootReducer, // create redux store using root reducer
  initialState = {}, // initial state of the application
  composeWithDevTools(
    applyMiddleware(
      // router and other middlewares
    )
  )
);

const App = props => (
  <Provider store={store}>
    <LocalizeProvider store={store}>
      <Router>
        <Route path="/" component={Main} />
      </Router>
    </LocalizeProvider>
  </Provider>
);

render(<App />, document.getElementById("root"));
```

No problem as `react-localize-redux` supports redux out of the box.

* First add `localizeReducer` as `localize` to your application's root reducer.
* Then wrap your application with [LocalizeProvider](#localizeprovider) and pass it your redux store.
* You can now wrap your components with the [withLocalize](#withlocalize) HOC to use [LocalizeContext](#localizecontext).

In addition, `react-localize-redux` provides some [Redux Helpers](#redux-helpers) that are not required but can be useful. You can access them by connecting your components to redux store using [connect](https://github.com/reduxjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options).

## Can I use a ImmutableJS store?

> ImmutableJS store:

```jsx
import React from "react";
import { render } from "react-dom";
import { createStore } from "redux";
import { LocalizeProvider, localizeReducer } from "react-localize-redux";
import Main from "./Main";

import { combineReducers } from 'redux-immutable';

class App extends React.Component<any, any> {
  constructor(props) {
    super(props);

    const store = createStore(
      combineReducers({
        localize: localizeReducer
      })
    );

    this.state = {
      store
    };
  }

  render() {
    return (
      <LocalizeProvider
        store={this.state.store} // this is a Map
        getState={state => state.get('localize')} // Map-compatible method
      >
        <Main />
      </LocalizeProvider>
    );
  }
}

render(<App />, document.getElementById("root"));
```

Yes, usage with ImmutableJS is supported, you just need to explicitly define how to access `state.localize`.

* Pass [LocalizeProvider](#localizeprovider) a function compatible with the data structure containing your store
* In this example our store is a `Map`, so we pass a function that calls `state.get()`.

## Why do I need to pass `renderToStaticMarkup` to initialize?

In order for [Translate](#translate-2) to handle default translations that contain HTML `react-localize-redux` requires react-dom/server's [renderToStaticMarkup](https://reactjs.org/docs/react-dom-server.html#rendertostaticmarkup) function. This function used to be included as part of the library, but in doing so
would cause issues in React Native, as it doesn't support `react-dom`. For this reason you now need to pass in a reference to react-dom/server's `renderToStaticMarkup` function to [initialize](#initialize) as an option when using `react-localize-redux` in browser.

## Can I use React Native?

> Set `renderToStaticMarkup` to `false`:

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";
import globalTranslations from "./translations/global.json";

class Main extends React.Component {
  constructor(props) {
    super(props);

    this.props.initialize({
      languages: [
        { name: "English", code: "en" },
        { name: "French", code: "fr" }
      ],
      translation: globalTranslations,
      options: {
        renderToStaticMarkup: false
      }
    });
  }

  render() {
    // render Main layout component
  }
}

export default withLocalize(Main);
```

You can use React Native, but will need to set `renderToStaticMarkup` to `false` when passing [initialize](#initialize) options.

One caveat is that React Native is unable to support passing default translations that contain HTML to [Translate](#translate-2). This is due to React Native not supporting
react-dom/server's [renderToStaticMarkup](https://reactjs.org/docs/react-dom-server.html#rendertostaticmarkup).

## What if my translation data isn't in the required format?

If you don't have control over the translation data for your application you can use the [translationTransform](#addtranslation) option.
See [Custom translation format](#custom-translation-format) guide for more details.

## How do I persist active language after refresh?

> Persist active language to local storage:

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";

class Main extends React.Component {
  constructor(props) {
    super(props);

    const languages = ["en", "fr", "es"];
    const defaultLanguage =
      window.storage.getItem("languageCode") || languages[0];

    this.props.initialize({
      languages,
      options: { defaultLanguage }
    });
  }

  componentDidUpdate(prevProps) {
    const prevLangCode =
      prevProps.activeLanguage && prevProps.activeLanguage.code;
    const curLangCode =
      this.props.activeLanguage && this.props.activeLanguage.code;

    const hasLanguageChanged = prevLangCode !== curLangCode;

    if (hasLanguageChanged) {
      window.storage.setItem("languageCode", curLangCode);
    }
  }

  render() {
    // render Main layout component
  }
}

export default withLocalize(Main);
```

Persisting the user’s active language after a refresh can be done a many ways, and how that is done is really up to you.
The following is one approach leveraging local storage to store and retrieve the active language.

## How do I handle currency, date, and other localization transformations?

> Basic localized number formatter

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";

const FormatNumber = props => {
  return props.activeLanguage
    ? Number(props.children).toLocaleString(props.activeLanguage.code)
    : null;
};

export default withLocalize(FormatNumber);
```

This logic was excluded on purpose in order to keep this API focused, and package size small. If you do require localization based formatting you do have the choice of using a third-party library that speciializes in formatting e.g([Moment](https://momentjs.com/) for dates). Or you can even implement this logic yourself...

## How does react-localize-redux differ from react-intl?

* [react-intl](https://github.com/yahoo/react-intl) is larger in size/complexity, and for good reason as it handles many things related to localization. e.g. Pluralization, currency. Where as with `react-localize-redux` you are responsible for those things - see [How do I handle currency, date, and other localization transformations?](#how-do-i-handle-currency-date-and-other-localization-transformations)

* `react-intl` doesn't work with Redux out of the box, and needs an additional library [react-intl-redux](https://github.com/ratson/react-intl-redux) to add support.

* For further discussion on this topic see [original github issue](https://github.com/ryandrewjohnson/react-localize-redux/issues/21).

# API Reference

## LocalizeProvider

> Wrap your app with `<LocalizeProvider />`

```jsx
import React from "react";
import { render } from "react-dom";
import { BrowserRouter as Router, Route } from "react-router-dom";
import { LocalizeProvider } from "react-localize-redux";
import Main from "./Main";

const App = props => (
  <LocalizeProvider>
    <Router>
      <Route path="/" component={Main} />
    </Router>
  </LocalizeProvider>
);

render(<App />, document.getElementById("root"));
```

By wrapping your application with `<LocalizeProvider />` all component's in the hierarchy below will have the ability to work with localize.

#### Properties:

| Property | Type        | Description                                        |
| -------- | ----------- | -------------------------------------------------- |
| store    | Redux store | Optionally pass your store if your app uses Redux. |

<aside class="notice">
<code>LocalizeProvider</code> is a wrapper around React's native <a href="https://reactjs.org/docs/context.html#provider">Context Provider</a>.
</aside>

## LocalizeContext

> Usage (use `withLocalize` instead when possible):

```jsx
import React from 'react';
import { LocalizeContext } from 'react-localize-redux';

const LastResort = props => (
  <LocalizeContext.Consumer>
    { context =>
      // you will have access to context props here
    }
  </LocalizeContext.Consumer>
);
```

It is recommended that you **don't use** `LocalizeContext` directly, but instead use the [withLocalize](#withlocalize) higher-order
component to access `LocalizeContext`'s props in your component.

<aside class="notice">
<code>LocalizeContext</code> is was created using <a href="https://reactjs.org/docs/context.html#reactcreatecontext">React.createContext</a> thus it can
be used like any other context created by React.
</aside>

### initialize

> Usage:

```jsx
import React from "react";
import { renderToStaticMarkup } from "react-dom/server";
import { withLocalize } from "react-localize-redux";
import globalTranslations from "./translations/global.json";

class Main extends React.Component {
  constructor(props) {
    super(props);

    this.props.initialize({
      languages: [
        { name: "English", code: "en" },
        { name: "French", code: "fr" }
      ],
      translation: globalTranslations,
      options: {
        renderToStaticMarkup,
        renderInnerHtml: true,
        defaultLanguage: "fr"
      }
    });
  }

  render() {
    // render Main layout component
  }
}

export default withLocalize(Main);
```

You will need to [initialize](#initialize) localize with the supported languages in your translations. Optionally you can
also provide initial translation data, as well as some additional options.

#### Properties:

| Property    | Type   | Description                                                                                                        |
| ----------- | ------ | ------------------------------------------------------------------------------------------------------------------ |
| languages   | array  | An array of languages your translations will support.                                                              |
| translation | object | Translation data in [all languages](#all-languages-format) or [single language](#single-language-format) format. |
| options     | object | See options table below.                                                                                           |

#### Options:

| Name                 | Type     | Default                         | Description                                                                                                                                                     |
| -------------------- | -------- | ------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| renderToStaticMarkup    | function | boolean                         | If using react in browser pass in react-dom/server's [renderToStaticMarkup](https://reactjs.org/docs/react-dom-server.html), and `false` if using React Native. |
| renderInnerHtml         | boolean  | false                           | Controls whether HTML in your translations will be rendered or returned as a plain string.                                                                      |
| onMissingTranslation    | function | returns default missing message | See [Handle missing translations](#handle-missing-translations) for details.                                                                                   |
| defaultLanguage         | string   | languages[0]                    | The language code for the language you'd like to set as the default.                                                                                            |
| ignoreTranslateChildren | boolean  | false                           | If `true` default translations passed as `children` to `Translate` will be ignored, and not automatically added to your translation data. Note that you can override this behaviour on a per-component instance by passing `options.ignoreTranslateChildren` as a prop to [Translate](#translate-2).
             |

<aside class="success">
  <a href="#why-do-i-need-to-pass-rendertostaticmarkup-to-initialize">Why do I need to pass <code>renderToStaticMarkup</code> to initialize?</a>
</aside>

<aside class="notice">
  Ensure you <code>initialize</code> localize before attempting to render any components that have translations in them.
</aside>

### addTranslation

> greetings.json (all languages format)

```javascript
{
  "greeting": ["Hello", "Bonjour"],
  "farewell": ["Goodbye", "Au revoir"]
}
```

> Usage:

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";
import greetings from "./translations/greetings.json";

class Greetings extends React.Component {
  constructor(props) {
    super(props);
    this.props.addTranslation(greetings);
  }
}

export default withLocalize(Greetings);
```

The `addTranslation` method is used to add translations data in the [all languages format](#all-languages-format) to localize.
Once you've translation data has been added you will be able to access it using [Translate](#translate-2).

#### Parameters:

| Name    | Type   | Description                                                         |
| ------- | ------ | ------------------------------------------------------------------- |
| data    | object | Translation data in [all languages format](#all-languages-format). |
| options | object | Optional configuration for translation data.                        |

#### Options:

| Name                 | Type     | Description                                                                                                      |
| -------------------- | -------- | ---------------------------------------------------------------------------------------------------------------- |
| translationTransform | function | A transform function for dealing with custom translation data. See [Custom translation format](#custom-translation-format). |

### addTranslationForLanguage

> en.greetings.json (single language format)

```javascript
{
  "greeting": "Hello",
  "farewell": "Goodbye"
}
```

> Usage:

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";
import greetings from "./translations/greetings.json";

class Greetings extends React.Component {
  constructor(props) {
    super(props);
    this.props.addTranslationForLanguage(greetings, "en");
  }
}

export default withLocalize(Greetings);
```

The `addTranslationForLanguage` method is used to add translations data in the [single language format](#single-language-format) to localize.
Once you've translation data has been added you will be able to access it using [Translate](#translate-2).

#### Parameters:

| Name     | Type   | Description                                                             |
| -------- | ------ | ----------------------------------------------------------------------- |
| data     | object | Translation data in [single language format](#single-language-format). |
| language | string | The language code this translation data belongs to.                     |

### setActiveLanguage

> Usage:

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";

const LanguageToggle = ({ languages, activeLanguage, setActiveLanguage }) => (
  <ul className="selector">
    {languages.map(lang => (
      <li key={lang.code}>
        <button onClick={() => setActiveLanguage(lang.code)}>
          {lang.name}
        </button>
      </li>
    ))}
  </ul>
);

export default withLocalize(LanguageToggle);
```

The `setActiveLanguage` method is used to change localize's active language.

#### Parameters:

| Name     | Type   | Description                                  |
| -------- | ------ | -------------------------------------------- |
| language | string | The language code you want to set as active. |

### translate

> Access translate function:

```jsx
import React from 'react';
import { Translate } from 'react-localize-redux';

const Page = () => (
  <Translate>
    {translate =>
      <h1>{ translate('heading') }</h1>
      // Instead of pulling translation based on activeLanguage,
      // specify language using defaultLanguage option
      <p>{ translate('heading', null, { defaultLanguage: 'fr' }) }</p>

      // override renderHtml option for this translation
      <p>{ translate('article.code', null, { renderInnerHtml: false }) }</p>

      // pass multiple translations
      <Article
        {...translate(['article.title', 'article.author'], { name: 'Ted' }) }
      />
    }
  </Translate>
);
```

The translate function will return single, or multiple translations depending on the arguments passed.
See [retrieving multiple translations](#retrieving-multiple-translations) for more detail.

#### Parameters:

| Parameter | Type   | Description                                                                                |
| --------- | ------ | ------------------------------------------------------------------------------------------ |
| id        | string | Pass a single id or multiple ids for the translation you want to insert.                   |
| data      | object | Optional data for variable replacements in [dynamic translations](#dynamic-translations). |
| options   | object | See options table below.                                                                   |

#### Options:

| Name                 | Type     | Description                                                                         |
| -------------------- | -------- | ----------------------------------------------------------------------------------- |
| language             | string   | Optionally pass a language code to force `Translate` to render a specific language. |
| renderInnerHtml      | boolean  | Override initialize [renderInnerHtml](#initialize) option for translation.         |
| onMissingTranslation | function | Override initialize [onMissingTranslation](#initialize) option for translation.    |

### languages

> Usage:

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";

const Languages = ({ languages }) => (
  <ul>
    {languages.map(language => (
      <li>
        {language.name} - {language.code}
      </li>
    ))}
  </ul>
);

export default withLocalize(ActiveLanguage);
```

An array of languages your translations will support. These are the same languages you passed to [initialize](#initialize).

### activeLanguage

> Usage:

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";

const ActiveLanguage = ({ activeLanguage }) => (
  <ul>
    <li>code: {activeLanguage.code}</li>
    <li>name: {activeLanguage.name}</li>
  </ul>
);

export default withLocalize(ActiveLanguage);
```

The current active language in localize.

#### language format:

**`{ code: 'en', name: 'English', active: true }`**

### defaultLanguage

> Usage:

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";

const DefaultLanguage = ({ defaultLanguage }) => (
  <h1>The default language code is: {defaultLanguage}</h1>
);

export default withLocalize(DefaultLanguage);
```

The default language code in localize. The default language was set when you called
localize [initialize](#initialize).

<aside class="notice">
The default language is the first language by default
unless your set a <code>defaultLanguage</code> option with <code>initialize</code>.
</aside>

## withLocalize

> Usage:

```jsx
import React from "react";
import { withLocalize } from "react-localize-redux";

const LanguageToggle = ({ languages, activeLanguage, setActiveLanguage }) => (
  <ul>
    {languages.map(language => (
      <li key={language.code}>
        <button onClick={() => setActiveLanguage(language.code)}>
          {language.name}
        </button>
      </li>
    ))}
  </ul>
);

export default withLocalize(LanguageToggle);
```

By wrapping your component with the `withLocalize` higher-order component all props from
[LocalizeContext](#localizecontext) will be added as props to your wrapped component.

## Translate

> Given following translations

```javascript
{
  greeting: [null, 'Bonjour'],
  farewell: ['goodbye', 'Au revoir'],
  food: [null, '<ul><li>Lait</li><li>biscuits</li></ul>'],
  date: [null, 'La date d\'aujourd\'hui est ${date}']
}
```

> Add translations with `<Translate/>`:

```jsx
import React from "react";
import { Translate } from "react-localize-redux";

const Welcome = props => (
  <div>
    {/*
      'Hello' would be inserted into translation data under the
      default language for translation id 'greeting'.
    */}
    <Translate id="greeting">Hello</Translate>

    {/*
      Override 'goodbye' with 'Bye Bye!' in translation data under the
      default language for translation id 'farewell'.
    */}
    <Translate id="farewell">Bye Bye!</Translate>

    {/*
      If you do self-closing with no default translations ensure you have
      a translation for the default language in your data.
    */}
    <Translate id="farewell" />

    {/*
      Include HTML markup as children, but ensure you include
      the same markup in your translation data for other languages.
    */}
    <Translate id="food">
      <ul>
        <li>Milk</li>
        <li>Cookies</li>
      </ul>
    </Translate>

    {/*
      Insert translations with placeholder's for dynamic data
      and pass data in using data prop.
    */}
    <Translate id="date" data={{ date: new Date() }}>
      {"Today's date is ${date}"}
    </Translate>

    {/*
      Override initialize options using the options prop.
      Overriding renderInnerHtml to false to avoid rendering HTML markup.
    */}
    <Translate id="food" options={{ renderInnerHtml: false }}>
      <ul>
        <li>Milk</li>
        <li>Cookies</li>
      </ul>
    </Translate>
  </div>
);
```

The `<Translate />` component is how you access your translations from your components.

##### Translate Props:

| Name    | Type   | Description                                                                                |
| ------- | ------ | ------------------------------------------------------------------------------------------ |
| id      | string | The id for the translation you want to insert.                                             |
| data    | object | Optional data for variable replacements in [dynamic translations](#dynamic-translations). |
| options | object | See options table below.                                                                   |

#### Options:

| Name                    | Type     | Description                                                                                                                               |
| ----------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| language                | string   | Optionally pass a language code to force `Translate` to render a specific language.                                                       |
| renderInnerHtml         | boolean  | Override initialize [renderInnerHtml](#initialize) option for translation.                                                               |
| onMissingTranslation    | function | Override initialize [onMissingTranslation](#initialize) option for translation.                                                          |
| ignoreTranslateChildren | boolean  | If `true` default translations passed as `children` to `Translate` will be ignored, and not automatically added to your translation data. |

### Render props API:

> Render props usage:

```jsx
import React from "react";
import { Translate } from "react-localize-redux";

const LanguageInfo = () => (
  <Translate>
    {({ translate, activeLanguage, languages }) => (
      <div>
        <h1>{translate("label-active")}</h1>
        <p>
          {activeLanguage.name} - {activeLanguage.code}
        </p>

        <h2>{translate("label-languages")}</h2>
        <ul>
          {languages.map(language => (
            <li>
              {language.name} - {language.code}
            </li>
          ))}
        </ul>
      </div>
    )}
  </Translate>
);
```

You can also pass Translate a function as it's child that returns the elements you want to render. This function is commonly referred to as a [render prop function](https://reactjs.org/docs/render-props.html), and is passed a single object with the following props:

#### Properties:

| Property       | Type     | Description                                           |
| -------------- | -------- | ----------------------------------------------------- |
| translate      | function | See [translate function](<[translate](#translate)>). |
| activeLanguage | object   | The active language object.                           |
| languages      | array    | An array of languages your translations will support. |

## Redux Helpers

The following selectors are available, and may be useful for redux app's using [connect](https://github.com/reduxjs/react-redux/blob/master/docs/api.md#connectmapstatetoprops-mapdispatchtoprops-mergeprops-options).

### getTranslate

```jsx
const Greeting = ({ translate }) => <h1>{translate("greeting")}</h1>;

const mapStateToProps = state => ({
  translate: getTranslate(state.localize)
});

export default connect(mapStateToProps)(Greeting);
```

A selector that takes the `localize` slice of your state and returns the [translate](#translate) function.

### getActiveLanguage

```jsx
const Greeting = ({ currentLanguage }) => (
  <h1>My language is: {currentLanguage}</h1>
);

const mapStateToProps = state => ({
  currentLanguage: getActiveLanguage(state.localize).code
});

export default connect(mapStateToProps)(Greeting);
```

A selector that takes the `localize` slice of your state and returns the active language.

### getLanguages

```jsx
const LanguageSelector = ({ languages }) => (
  <ul>
    { languages.map(language => (
      <li>{ language.name }</li>
    )}
  </ul>
);

const mapStateToProps = state => ({
  languages: getLanguages(state.localize)
});

export default connect(mapStateToProps, { setActiveLanguage })(Greeting);
```

A selector that takes the `localize` slice of your state and returns the languages array.

### getTranslations

A selector that takes the `localize` slice of your state and returns all your translation data.

<br/>
<br/>
<br/>
