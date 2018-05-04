---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ

toc_footers:
  - <a href='#'>Sign Up for a Developer Key</a>
  - <a href='https://github.com/lord/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true
---

# Getting Started

Intro text can go here...





## Add LocalizeProvider

> Wrap your app with `<LocalizeProvider />`

```jsx
import React from 'react';
import { render } from 'react-dom';
import { BrowserRouter as Router, Route } from 'react-router-dom';
import { LocalizeProvider } from 'react-localize-redux';
import Main from './Main';

const App = props => (
  <LocalizeProvider>
    <Router>
      <Route path="/" component={Main} />
    </Router>
  </LocalizeProvider>
);

render(<App />, document.getElementById('root'));
```

By wrapping your application with `<LocalizeProvider />` all component's in the heirarchy below
will have the ability to work with localize.

<aside class="success">
<strong>Using Redux?</strong> — if you wish to store your translations in redux then all you need to do
is pass the redux <code>store</code> to <code>LocalizeProvider</code>.
</aside>




## Initialize localize

```jsx
import React from 'react';
import { withLocalize } from 'react-localize-redux';
import globalTranslations from './translations/global.json';

class Main extends React.Component {

  constructor(props) {
    super(props);

    this.props.initialize({
      languages: [
        { name: 'English', code: 'en' },
        { name: 'French', code: 'fr' }
      ],
      translation: globalTranslations
    });
  }

  render() {
    // render Main layout component
  }
}

export default withLocalize(Main);
```

Before accessing any trnaslations in your app you will need to [initialize]() localize with your settings.
The settings object requires `lanuages`, while `translation`, and `options` are optional.

Property | Type | Description
--------- | ------- | -----------
languages | array | An array of languages your translations will support.
translation | object | Translation data in [all languages]() or [single language]() format.
options | object | See [initialize options]().

<aside class="notice">
In order for your component to have access to the <code>initialize</code> prop you'll need to use the <code><a href="#">withLocalize</a></code> higher-order component.
</aside>

<aside class="notice">
Ensure you <code>initialize</code> localize before attempting to render any components that have translations in them.
</aside>







## Add translation data

> To add multi language translations, use `addTranslation`:

```jsx
import React from 'react';
import { withLocalize } from 'react-localize-redux';
import movieTranslations from './translations/movies.json';

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
import frenchMovieTranslations from './translations/fr.movies.json';

this.props.addTranslationForLanguage(frenchMovieTranslations, 'fr');
```

Translation data comes in two different flavours - the [all languages]() and [single language]() format.

* Use [addTranslation]() method  to add data in `all languges` format.
* Use [addTranslationForLanguage]() method to add data in `single languge` format.

As soon as you add the translation data to localize it can be rendered in your components using [Translate]().

<aside class="notice">
In order for your component to have access to the <code>addTranslation</code> and <code>addTranslationForLanguage</code> props you'll need to use the <code><a href="#">withLocalize</a></code> higher-order component.
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

Here is the intro text beside the JSON.


> With default language:

```jsx
import React from 'react';
import { Translate } from 'react-localize-redux';

const Movies = props => (
  <h1><Translate id="movie.title">Jurassic Park</Translate></h1>
);
```

### With children

Here is the text talking about Translate with children.


> With default language:

```jsx
const Movies = props => (
  <h1><Translate id="movie.title" /></h1>
);
```

### No children

Here is the text talking about Translate with no children.


> With render props:

```jsx
const Movies = props => (
  <Translate>
    {({ translate }) =>
      <h1>{ translate('movie.title') }</h1>
    }
  </Translate>
);
```

### Render props

Here is the text talking about render props.





## Change active language

```jsx
import React from 'react';
import { withLocalize } from 'react-localize-redux';

const LanguageToggle = ({languages, activeLanguage, setActiveLanguage}) => (
  <ul className="selector">
    {languages.map(lang =>
      <li key={ lang.code }>
        <button onClick={() => setActiveLanguage(lang.code)}>{ lang.name }</button>
      </li>
    )}
  </ul>
);

export default withLocalize(LanguageToggle);
```

Change active language content goes here...





# Formatting Translations

Translation data can be stored in either json or vanilla JS, but more importantly in order for `localize` to work with
your data it will need to be in one of the following formats.

## All langauges format

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

* Includes a translation for each language your app supports. TODO: exception being the default langauge
* The order of the translation strings in the array matters! The order **MUST** follow the order of the languages array passed to [initialize]().

<aside class="notice">
The <a href="#"><code>addTranslation</code></a> action requires translations in this format.
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

**Use this format when you want to have a translation file for each separate langauge.**

Translation data will be an object where the property name is your translation id, and the value is the translation for the language. The translation id must be unique across **all** your translations.

//TODO mention code splitting technique

<aside class="notice">
The <a href="#"><code>addTranslationForLanguage</code></a> action requires translations in this format.
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
import React from 'react';
import { Translate } from 'react-localize-redux';

const Greeting = props => (
  <div>
    <Translate id="welcome.greeting">Hello</Translate>
    <Translate id="welcome.farewell">Goodbye</Translate>
  </div>
);
```

Both types of translation data support nested data format to help with organization of translations, and avoiding naming collisions with translation keys.

// TODO: rewrite this...


## Custom format

// TODO: link to custom translation data guide section







# Guides


## Include inline default translations

> Pass default language translations to `Translate`

```jsx
import React from 'react';
import { Translate } from 'react-localize-redux';

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

With [Translate]() you can include an inline translation for the defualt langauge by passing it
as `children` to the component.

When you pass an inline translation to `Translate` it will be added to your translation data under the corresponding `id`
for the default language. If the default langauge's translation for that `id` already exists it will be overriden
with the inline translation.

If you don't want existing translation data overriden you can set `Translate`'s [ignoreTranslateChildren]() option to `true`.
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
import React from 'react';
import { Translate } from 'react-localize-redux';

const Greeting = props => (
  <Translate id="greeting" data={{name: 'Testy McTest'}}>
    {'Hello ${ name }'}
  </Translate>
);
```

> Using render props

```jsx
import React from 'react';
import { Translate } from 'react-localize-redux';

const Today = props => (
  <Translate>
    {({ translate }) =>
      <h1>{ translate('today', { date: Date.now() }) }</h1>
    }
  </Translate>
);
```

You can add dynamic content to your translatins by inserting placeholders with the following format `${placeholder}`.
Then using the [Translate]() component you will be able to pass in data that will inserted for each corresponding placeholder.


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
import React from 'react';
import { Translate } from 'react-localize-redux';

const Link = props => (
  <Translate id="google-link" options={{ renderInnerHtml: false }} />
);

// with render props
const Link = props => (
  <Translate>
    {({ translate }) =>
      <p>{ translate('google-link', null, { renderInnerHtml: false })}</p>
    }
  </Translate>
);
```

As long as you've set the [initialize]() option [renderInnerHtml]() to `true` any HTML markup in your translations
will be rendered when using [Translate]().

In addition to setting `renderInnerHtml` globally you can also override it for a specific translation's by passing an
[options]() prop to `Translate`.


## Handle missing translations

By default when a translation isn't found the following message will be rendered in it's place:

**`Missing translationId: ${ translationId } for language: ${ languageCode }`**

> Return translation for default language in place of missing translation

```jsx
import React from 'react';
import { withLocalize } from 'react-localize-redux';

const onMissingTranslation = ({ defaultTranslation }) => defaultTranslation;

class Missing extends React.Component {

  constructor(props) {
    super(props);

    this.props.initialize({
      languages: ['en', 'fr'],
      options: { onMissingTranslation }
    });
  }
}

export default withLocalize(Missing);
```

> Override onMissingTranslation for specific translation

```jsx
import React from 'react';
import { Translate } from 'react-localize-redux';

const onMissingTranslation = ({ translationId, languageCode }) => {
  return `Nada for ${ translationId } - ${ languageCode }`;
}

const Missing = props => (
  <Translate id="missing" options={{ onMissingTranslation }} />
);
```

### Adding custom missing translation logic

This can be overidden at a global level by providing the [onMissingTranslation]() option to [initialize]().
You'll need to pass `onMissingTranslation` a function for it's value, and that function should return
a string that will be rendered in the missing translation's place.

The `onMissingTranslation` function will receive a single argument - an object with the following properties:

Property | Type | Description
--------- | ------- | -----------
translationId | string | The id for the missing translation
languageCode | string | The languageCode for the language being retrieved
defaultTranslation | string | The translation for the default language - *if defined*


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
import React from 'react';
import { Translate } from 'react-localize-redux';

const Article = props => (
  <div>
    <h2>{ props['greeting'] }</h2>
    <p>{ props['today'] }</p>
  </div>
);

const Page = ({ translate }) => (
  <Translate>
    {({ translate })} =>
      <Article
        { ...translate(['greeting', 'today'], { name: 'Ted', date: Date.now() }) }
      />
    }
  </Translate>
);
```

To retrieve multiple translations using [translate]() pass an array of translation ids instead of a single id. This will return an object with translated strings mapped to translation ids.


## Custom translation format

> Unsupported translation format

```javascript
const customTranslation = {
  en: {
    greeting: 'Hello',
    farewell: 'Goodbye'
  },
  fr: {
    greeting: 'Bonjour',
    farewell: 'Au Revoir'
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
import React from 'react';
import { withLocalize } from 'react-localize-redux';

const transformFunction = (translationData: Object, languagesCodes: string[]) => {
  // Your transformation logic goes here...
};

class CustomStuff extends React.Component {

  constructor(props) {
    super(props);

    this.props.addTranslation(
      customTranslation,
      { translationTransform: transformFunction }
    );
  }
}

export default withLocalize(CustomStuff);
```

Do you have legacy translation data that doesn't fit one of localize's [supported formats]()? In this case you can try [addTranslation]()'s
[translationTransform]() option, which can be passed when adding translations.

The `translationTransform` option takes a function that is responsible for transforming your custom translation data into localize's supported [all langauges format]().

The translation function will be passed the below arguments, and should return data in `all languages format`:

Parameter | Type | Description
--------- | ------- | -----------
translationData | Object | The custom translation data before transformation
languagesCodes | string[] | An array of languageCodes based on languages passed to initialize





# FAQ

## What if my translation data isn't in the required format?

If you don't have control over the translation data for your application you can use the [translationTransform]() option.
See [Custom translation format]() for more details.


## How do I persist active language after refresh?

```jsx
import React from 'react';
import { withLocalize } from 'react-localize-redux';

class Main extends React.Component {

  constructor(props) {
    super(props);

    const languages = ['en', 'fr', 'es'];
    const defaultLanguage = window.storage.getItem('languageCode') || languages[0];

    this.props.initialize({
      languages,
      options: { defaultLanguage }
    });
  }

  componentDidUpdate(prevProps) {
    const prevLangCode = prevProps.activeLanguage && prevProps.activeLanguage.code;
    const curLangCode = this.props.activeLanguage && this.props.activeLanguage.code;

    const hasLanguageChanged = prevLangCode !== curLangCode;

    if (hasLanguageChanged) {
      window.storage.setItem('languageCode', curLangCode);
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
import React from 'react';
import { withLocalize } from 'react-localize-redux';

const FormatNumber = props => {
  return props.activeLanguage
    ? Number(props.children).toLocaleString(props.activeLanguage.code)
    : null;
}

export default withLocalize(FormatNumber);
```

This logic was excluded on purpose in order to keep this API focused, and package size small. If you do require localization based formatting you do have the choice of using a third-party library that speciializes in formatting e.g([Moment](https://momentjs.com/) for dates). Or you can even implement this logic yourself...


## How does react-localize differ from react-intl?

* [react-intl](https://github.com/yahoo/react-intl) is larger in size/complexity, and for good reason as it handles many things related to localization. e.g. Pluralization, currency. Where as with `react-localize` you are responsible for those things - see [How do I handle currency, date, and other localization transformations?]()

* `react-intl` doesn't work with Redux out of the box, and needs an additional library [react-intl-redux](https://github.com/ratson/react-intl-redux) to add support. // TODO: links to redux implementation

* For further discussion on this topic see [original github issue](https://github.com/ryandrewjohnson/react-localize-redux/issues/21).


## Can I use older versions of React?

// TODO: do I need this section





# API Reference

## LocalizeProvider


## initialize

> Usage:

```jsx
import React from 'react';
import { withLocalize } from 'react-localize-redux';
```
### Parameters

Name | Type | Description
--------- | ------- | -----------
options | object |

### Options

Name | Type | Description
--------- | ------- | -----------
renderInnerHtml | boolean |
onMissingTranslation | function |
defaultLanguage | string |



## addTranslation

> Usage:

```jsx
import React from 'react';
import { withLocalize } from 'react-localize-redux';
```

The `addTranslation` method is used to add translations data in the [all languages format]() to localize.
Once you've translation data has been added you will be able to access it using [Translate]().

### Parameters

Name | Type | Description
--------- | ------- | -----------
data | object | Translation data in [all languages format]().
options | object | Optional configuration for translation data.

### Options

Name | Type | Description
--------- | ------- | -----------
translationTransform | function | A transform function for dealing with custom translation data. See [Custom translation format]().


## addTranslationForLanguage

> Usage:

```jsx
import React from 'react';
import { withLocalize } from 'react-localize-redux';
```

The `addTranslationForLanguage` method is used to add translations data in the [single language format]() to localize.
Once you've translation data has been added you will be able to access it using [Translate]().

### Parameters

Name | Type | Description
--------- | ------- | -----------
data | object | Translation data in [single language format]().
language | string | The language code this translation data belongs to.


## setActiveLanguage

> Usage:

```jsx
import React from 'react';
import { withLocalize } from 'react-localize-redux';
```

The `setActiveLanguage` method is used to change localize's active language.

### Parameters

Name | Type | Description
--------- | ------- | -----------
language | string | The language code you want to set as active.


## Translate

The `<Translate />` component is how you access your translations from your components.

### Props

Name | Type | Description
--------- | ------- | -----------
id | string | The id for the translation you want to insert.
data | object | Optional data for variable replacements in [dynamic translations]().
options | object |

### Options

Name | Type | Description
--------- | ------- | -----------
language | string |
renderInnerHtml | boolean |
onMissingTranslation | function |
ignoreTranslateChildren | boolean |


## withLocalize


## LocalizeContext





## Get All Kittens

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get()
```

```shell
curl "http://example.com/api/kittens"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let kittens = api.kittens.get();
```

> The above command returns JSON structured like this:

```json
[
  {
    "id": 1,
    "name": "Fluffums",
    "breed": "calico",
    "fluffiness": 6,
    "cuteness": 7
  },
  {
    "id": 2,
    "name": "Max",
    "breed": "unknown",
    "fluffiness": 5,
    "cuteness": 10
  }
]
```

This endpoint retrieves all kittens.

### HTTP Request

`GET http://example.com/api/kittens`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
include_cats | false | If set to true, the result will also include cats.
available | true | If set to false, the result will include kittens that have already been adopted.

<aside class="success">
Remember — a happy kitten is an authenticated kitten!
</aside>

## Get a Specific Kitten

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get(2)
```

```shell
curl "http://example.com/api/kittens/2"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.get(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "name": "Max",
  "breed": "unknown",
  "fluffiness": 5,
  "cuteness": 10
}
```

This endpoint retrieves a specific kitten.

<aside class="warning">Inside HTML code blocks like this one, you can't use Markdown, so use <code>&lt;code&gt;</code> blocks to denote code.</aside>

### HTTP Request

`GET http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to retrieve

## Delete a Specific Kitten

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```shell
curl "http://example.com/api/kittens/2"
  -X DELETE
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "deleted" : ":("
}
```

This endpoint deletes a specific kitten.

### HTTP Request

`DELETE http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to delete

