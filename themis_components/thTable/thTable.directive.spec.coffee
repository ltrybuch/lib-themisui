context = describe
describe "ThemisComponents: Directive: thTable", ->
  SimpleTableDelegate = element = null

  beforeEach ->
    module 'ThemisComponents'

    inject (_SimpleTableDelegate_) ->
      SimpleTableDelegate = _SimpleTableDelegate_

  it "renders a simple table", ->
    data = [
      {name: "First"}
      {name: "Second"}
    ]

    fetchData = (options, updateData) -> updateData {data}

    tableDelegate = SimpleTableDelegate {fetchData}

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

    tableDelegate = SimpleTableDelegate {fetchData}
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
