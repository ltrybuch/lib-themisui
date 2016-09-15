{
  compileDirective
} = require "spec_helpers"
context = describe

describe "ThemisComponents: Directive: thTable", ->
  SimpleTableDelegate = TableHeader = element = null

  beforeEach angular.mock.module 'ThemisComponents'
  beforeEach inject (_SimpleTableDelegate_, _TableHeader_) ->
    SimpleTableDelegate = _SimpleTableDelegate_
    TableHeader = _TableHeader_

  it "renders a simple table", ->
    data = [
      {name: "First"}
      {name: "Second"}
    ]

    fetchData = (options, updateData) -> updateData {data}

    tableDelegate = SimpleTableDelegate {
      headers: [
        TableHeader
          name: 'First'
        TableHeader
          name: 'Second'
      ]
      fetchData
    }

    {element} = compileDirective """
      <th-table delegate="tableDelegate">
        <th-table-row type="cells">
          <th-table-cell>
            <div class="find-me">
              {{item.name}}
            </div>
          </th-table-cell>
        </th-table-row>
      </th-table>
    """, {tableDelegate}

    renderedData = element
                    .find('.find-me')
                    .map (idx, node) -> node.textContent.trim()
                    .toArray()
    expectedData = data.map (object) -> object.name
    expect(renderedData).toEqual expectedData

  it "has access to the parent scope", ->
    data = [
      {name: "First"}
    ]

    fetchData = (options, updateData) -> updateData {data}

    tableDelegate = SimpleTableDelegate {
      headers: [
        TableHeader
          name: 'First'
      ]
      fetchData
    }
    outsider = "outsideValue"

    {element} = compileDirective """
      <th-table delegate="tableDelegate">
        <th-table-row type="cells">
          <th-table-cell>
            <div class="find-me">
              {{outsider}}
            </div>
          </th-table-cell>
        </th-table-row>
      </th-table>
    """, {tableDelegate, outsider}

    renderedData = element
                    .find('.find-me')
                    .text()
                    .trim()
    expect(renderedData).toEqual outsider
