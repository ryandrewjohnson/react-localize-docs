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

Initialize localize content goes here...





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

Add translation data content goes here...





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

Both types of translation data support nested data format to help with organization of translations, and avoiding naming collisions with translation keys.

// TODO: rewrite this...


## Custom format

> Your transform function will be passed the following arguments:

```javascript
const transformationFunction = (translationData: Object, languagesCodes: string[]) => {
  // Your transformation logic goes here...
};
```

If the above formats don't work you do have the option of setting the [translationTransform]() option when you [initialize]() localize. The `translationTransform` option takes a function that is responsible for taking your custom translation data, and transforming it into the [all langauges format]().

// TODO: where to put example.. here or in features section?





# Guides

## Adding dynamic content to translations

> Translations with placeholders

```json
{
  greeting: "Hello, ${name}!",
  today: "Today is ${date}"
}
```

> Using data attribute

```jsx
const Greeting = props => (
  <Translate id="greeting" data={{name: 'Testy McTest'}}>
    {'Hello ${ name }'}
  </Translate>
);
```

> Using render props

```jsx
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





# Authentication

> To authorize, use this code:

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
```

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here"
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
```

> Make sure to replace `meowmeowmeow` with your API key.

Kittn uses API keys to allow access to the API. You can register a new Kittn API key at our [developer portal](http://example.com/developers).

Kittn expects for the API key to be included in all API requests to the server in a header that looks like the following:

`Authorization: meowmeowmeow`

<aside class="notice">
You must replace <code>meowmeowmeow</code> with your personal API key.
</aside>

# Kittens

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

