# ThemisUI

[![Usage Docs](https://img.shields.io/badge/%E2%96%B6-Usage_Docs-3D7BBA.svg)](http://themisui-docs.clio.com/)
[![GitHub](https://img.shields.io/github/forks/badges/shields.svg?style=social&label=Fork)](https://github.com/clio/lib-themisui/)


ThemisUI is a shareable suite of components and brand assets to be shared across Themis projects. ThemisUI also contains a docs viewer to allow for simple consumption of components.

<!-- TOC depthFrom:2 depthTo:3 withLinks:1 updateOnSave:1 orderedList:0 -->

- [Installing](#installing)
- [Upgrading](#upgrading)
- [Development](#development)
	- [KendoUI Authentication](#kendoui-authentication)
	- [Running Docs](#running-docs)
	- [Running Tests](#running-tests)
	- [Cutting Code](#cutting-code)
	- [Coding Style](#coding-style)
- [Package Contents](#package-contents)
- [Deploying Docs](#deploying-docs)
- [Other Notes](#other-notes)
	- [Installing `node` / `npm`](#installing-node-npm)

<!-- /TOC -->

## Installing

We're running in stealth mode for now meaning we don't yet want to list on NPM. So to
install run:

```bash
npm install --save git://github.com/clio/lib-themisui#<release-tag>
```

You can specify [any other release](https://github.com/clio/lib-themisui/releases) as
well.

Next you just need to include ThemisUI in your angular application like so:

```javascript
angular = require('angular');

angular.module 'YourApp', [
    require 'lib-ThemisUI'
];
```

You must include the stylesheets as well:

* `node_modules/lib-ThemisUI/dist/lib-themisui.css`: the entire CSS
* `node_modules/lib-ThemisUI/src/themes/themis/index.scss`: optional, SCSS variables
defined for the Themis theme

You can now use any of our components in your application. The APIs for each
component explain their usage.

## Upgrading

Upgrading your project to a new version of ThemisUI is simple just run the following
command with your desired [release-tag](https://github.com/clio/lib-themisui/releases).

`--save` will persist the upgrade in your `package.json` and, if relevant, also your
shrinkwrap file.

```bash
npm install --save git://github.com/clio/lib-themisui#<release-tag>
```

For example to install version [`v0.9.0 — No More Mr Nice Guy`](https://github.com/clio/lib-themisui/releases/tag/v0.9.0)
you would run the following command.

```bash
npm install --save git://github.com/clio/lib-themisui#v0.9.0
```

## Development

### KendoUI Authentication
ThemisUI depends on the kendoUI component library. In order to develop, you are
required to have a valid license assigned to your email. Once you have been
granted a license, do the following to authenticate your license with npm.

```bash
npm login --registry=https://registry.npm.telerik.com/ --scope=@progress
```
You should be prompted for a username/password.

### Running Docs

Whilst inside the `lib-ThemisUI` directory.

1. Ensure you have npm installed.
2. Do a `npm install` to get dependencies.
3. Run `npm start` to start all the tasks we need and launch the server.
4. Visit http://localhost:3042
5. ???
6. Profit

**Note:** Certain demos will require access to files hosted from your local server when viewed on CodePen.
You may install browser extensions like [Allow-Control-Allow-Origin:*](https://github.com/vitvad/Access-Control-Allow-Origin)
to temporarily allow CORS.

### Running Tests

1. Ensure you have npm installed.
2. Do a `npm install` to get dependencies.
3. Run `npm test` to start karma.

It's recommended that you leave `npm test` running as you dev. Karma will watch your
files and tests and re-run when appropriate. If you're on OS X or Linux you'll even
get notifications of the test state as you work.

### Cutting Code

Give the [Running Docs](#running-docs) and [Running Tests](#running-tests) sections
above a quick read through. All the components, their css and tests are kept in the
`src/lib` directory. If you want to look at a simple component to get
started I'd recommend `th-switch`.

If you are integrating ThemisUI into an external project and would like to test a new
or revised component before a release is cut you can easily temporarily install from
a third party fork / commit.

```bash
npm install github:<githubname>/<githubrepo>#<commit-ish>
```

To ensure that you don't accidentally drift your main project off of a primary
release you'll want to take note on if it is appropriate to use `--save` when doing
your `npm install`. If you specify `--save` then the `package.json` and shrinkwrap
file (if relevant) will both be updated to the specified version / commit ref. This
may not be what you want for a simple component test.

### Coding Style

To adhere to our style guide we recommend using a linter addon for your code editor,
which will enforce the rules defined under `coffeelint.json`. These rules will be
enforced by our CI system.

* Atom:
 * https://atom.io/packages/linter
 * https://atom.io/packages/linter-coffeelint

* SublimeText:
 * http://sublimelinter.readthedocs.org
 * https://github.com/SublimeLinter/SublimeLinter-coffeelint


## Package Contents

- `src/lib`
  - A library of reusable components.
- `src/themes/themis`
  - Our base brand / fonts / icons / colours.


## Deploying Docs

1. Open a pull request from `master` against `edge` branch.
2. When your pull request is approved and merged it will automatically deploy and be visibile at http://themisui-docs.clio.com/.

## Other Notes

### Installing `node` / `npm`

#### Mac

1. Run `brew update` to ensure that the brew formulae are up to date.
2. Install node with `brew install node`.
