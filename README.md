# ThemisUI

[![Usage Docs](https://img.shields.io/badge/%E2%96%B6-Usage_Docs-3D7BBA.svg)](http://themisui-docs.clio.com/)
[![Build Status](https://travis-ci.org/clio/lib-themisui.svg)](https://travis-ci.org/clio/lib-themisui)
[![Coverage Status](https://coveralls.io/repos/clio/lib-themisui/badge.svg?branch=master&service=github)](https://coveralls.io/github/clio/lib-themisui?branch=master)

ThemisUI is a shareable suite of components and brand assets to be shared across Themis projects. ThemisUI also contains a docs viewer to allow for simple consumption of components.


## Usage

We're running in stealth mode for now meaning we don't yet want to list on NPM. So to install run:

```bash
npm install git+ssh://git@github.com/clio/lib-themisui.git
```

You can specify [any other release](https://github.com/clio/lib-themisui/releases) as well.

Next you just need to include ThemisUI in your angular application like so:

```javascript
angular = require('angular');

angular.module 'YourApp', [
    require 'lib-ThemisUI'
];
```

You can now use any of our components in your application. The APIs for each component explain their usage.


## Running Docs

### Getting started.

Whilst inside the `lib-ThemisUI` directory.

1. Ensure you have npm installed.
2. Do a `npm install` to get dependencies.
3. Run `npm start` to start all the tasks we need and launch the server.
4. Visit http://localhost:3042
5. ???
6. Profit

### Tests

1. Ensure you have npm installed.
2. Do a `npm install` to get dependencies.
3. Run `npm test` to start karma.

### Installing `node` / `npm`

### Mac

1. Run `brew update` to ensure that the brew formulae are up to date.
2. Install node with `brew install node`.


## Contents

- `themis_components`
  - A library of reusable components.
- `themis_theme`
  - Our base brand / fonts / icons / colours.


## Deploying Docs viewer

1. Open a pull request from `master` against `edge` branch.
2. When your pull request is approved and merged it will automatically deploy and be visibile at http://themisui-docs.clio.com/.

## Development

To adhere to our style guide we recommend using a linter addon for your code
editor, which will enforce the rules defined under `coffeelint.json`:

* Atom:
 * https://atom.io/packages/linter
 * https://atom.io/packages/linter-coffeelint

* SublimeText:
 * http://sublimelinter.readthedocs.org
 * https://github.com/SublimeLinter/SublimeLinter-coffeelint
