# Scheduler

`th-scheduler` is used to display and edit calendar data.

### Example

```html
<th-scheduler options="demo.options"></th-scheduler>
```

## API Reference

### Properties
| Property        | Type        | Description   |   |
|:-------------   |:-------     | :-------------|---|
| **options**     | Object      | The main configuration object for the component. | *required* |

### Options
Configure th-scheduler by providing the following parameters. Refer to the Demos for code samples.

* `options` (**required**) represents a dictionary of arguments passed to the component.
  * `dataSource` (**required**) - Use ```SchedulerDataSource.createDataSource({})```
  which takes any valid [kendo.data.SchedulerDataSource](http://docs.telerik.com/kendo-ui/api/javascript/data/schedulerdatasource) options.

### Pre-Reading
`thScheduler` makes extensive use of the <a href="doc/fixtures">Fixtures</a> concept. It is a good idea to understand the basics of how
we use them.
