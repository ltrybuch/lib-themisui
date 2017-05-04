# Component Creation

## Table of contents
1. [CLI tool](#cli-tool)
2. [Development](#development)
    1. [Kendo UI HTML framework](#kendo-ui-html-framework)
    2. [Component documentation](#component-documentation)
    3. [Badges](#badges)
    4. [Live demos](#live-demos)
3. [Testing](#testing)
    1. [Mocking data](#mocking-data)
    2. [Accessibility](#accessibility)
4. [Sign-off](#sign-off)
5. [QA](#qa)
    1. [Themis beta environment](#themis-beta-environment)
    2. [Test plan](#test-plan)
    3. [Feature team testing](#feature-team-testing)
6. [Tips](#tips)
    1. [Support Team Notification](#support-team-notification)


## CLI tool
You can use the generate scripts command to generate a new ThemisUI component:

```bash
npm run generate
```

1. Select Component and hit enter
2. Enter a name for your new component and hit enter

*<span class="badge orange">!</span> The component name should be supplied to you in the design specs.*

### Source location
Your new component source is located at `~/src/lib/th${componentName}`


## Development
To begin developing your new component, start the element catalog and navigate to your component by selecting it from the "Components" section in the menu.

```bash
npm start
```

The element catalog will automatically refresh and reflect changes when you have updated the component source.

### Kendo UI HTML framework
Many of the components in ThemisUI use the [Kendo UI HTML Framework](http://www.telerik.com/kendo-ui) as the backing library. When creating a new component, make sure to check the [widgets](http://www.telerik.com/kendo-ui#Widgets) to see if the component should use Kendo UI for its internals.

**Required steps**: [Authenticate to KendoUI servers](http://docs.telerik.com/kendo-ui/intro/installation/npm#installation)

*<span class="badge orange">!</span> All ThemisUI components should be exposed under the th- namespace, even if they are backed by a Kendo UI widget*



### Component documentation
Open `~/src/lib/th${componentName}/readme.md` and update with your component information. We like to ship our components early and often, so a proper metadata badge should be selected for the component to let users know the development status.

#### Badges
| Badge                                         | Description   | Markup  |
|:-------------                                 | :-------------|---|
| <span class="badge green">Ready</span>        | Ready for use in production | `<span class="badge green">Ready</span>` |
| <span class="badge blue">Testing</span>       | Ready but the component has not been battle tested yet  | `<span class="badge blue">Testing</span>` |
| <span class="badge orange">In Progress</span> | Beta. Not ready for production | `<span class="badge orange">In Progress</span>` |
| <span class="badge red">Deprecated</span>     | Still supported but should not be used for new features | `<span class="badge red">Deprecated</span>` |

### Live demos
You should build live demos for your component. The demos live in the `~/src/lib/th${componentName}/examples` folder. The goal is to show the major variations for a component that you think the feature teams would find useful. If you require test data for your demos, the [Fixtures Guideline](/doc/fixtures) covers our approach to demo and test setup data.

*<span class="badge orange">!</span> The product designer is a great resource to help you determine which demos are needed*

#### Demo early and often with design
During development, it is extremely important to do frequent demos for your product designer. By shortening the feedback loop, we can avoid lengthy rewrites and missed features.

## Testing
The component generator creates a spec file to help you get started with testing your new component, located at `~/src/lib/th${componentName}/tests/${component-name}.component.spec.ts`.

The test runner will watch for changes in your tests and automatically re-run tests when the source has changed.

```bash
npm test
```

### Mocking data
See the [fixtures section on test usage](/doc/fixtures#usage) for an example on how to use test data with a fake API Response.

The following components are a good reference point for testing:

* Scheduler - `~/src/lib/thScheduler/tests/`
* Autocomplete - `~/src/lib/thScheduler/tests/`

### Accessibility
Use the "Designing for Accessibility" checklist (<a href="https://themis.atlassian.net/wiki/pages/viewpage.action?pageId=163905994#DesigningforAccessibility(Checklist)-ScreenreaderChecklist(Web)">Screenreader Checklist section only</a>) to audit a11y during QA

## Sign-off
When you are ready to ship your new component you are required to have the following fields on your ticket signed-off.

* Sign-Off (Design: UI)
* Sign-Off (Developer: FE)
* Sign-Off (Developer) - Can be the same reviewer as the Developer: FE

## QA
All component changes should be integration tested in Themis. Do not assume that because it works in the ThemisUI Element Catalog, that it will work as expected when added to Themis.

### Themis Beta environment
To build a beta environment, do the following:

1. Create a new branch in Themis that matches the name of your ThemisUI feature branch.

```bash
git checkout master
git checkout -b clio-xyzlk-feature-branch-name upstream/master
```

2. Install your ThemisUI feature branch as a dependency.
```bash
npm i --save git+ssh://git@github.com/<github-username>/lib-themisui.git#clio-xyzlk-feature-branch-name
```

Note: This should result in your `~/package.json` AND `~/npm-shrinkwrap` being updated to point to your feature branch.

3. Push your changeset up to GitHub

4. Use [Beta Manager](http://beta-manager.clio.systems/) to create your new testing url.

### Test plan
A standard test plan should be created on your ticket. If your test plan will be used across multiple tickets, consider creating a [reusable component test plan](https://themis.atlassian.net/wiki/display/PDEV/Component+Test+Plans).

### Feature team testing
**Feature teams should be looped in on all component changes that are being deployed**. They should be given notification before the work starts so that they can inject testing tickets and account for the time required to validate the component change in their domain area.

## Tips

### Support Team Notification
Before you deploy a new component or changes to an existing one, make sure to notify the Clio support team. This gives them time to update any
documentation/training plans that they have in addition to them being aware that calls may come in if the change causes issues.
