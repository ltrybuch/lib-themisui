context = describe
describe 'ThemisComponents: Service: thTable', ->
  Table = SimpleTableDelegate = null

  createDOMElement = (template) ->
    div = document.createElement 'div'
    div.innerHTML = template
    div.firstChild

  beforeEach ->
    module 'ThemisComponents'

    inject (_Table_, _SimpleTableDelegate_) ->
      Table = _Table_
      SimpleTableDelegate = _SimpleTableDelegate_

  it 'exists', ->
    expect(Table?).toBe true

  describe '#constructor', ->
    it 'throws if no element is passed', ->
      expect(-> Table()).toThrow()

    it "throws if it doesn't have any rows", ->
      template = """
        <th-table></th-table>
      """
      element = createDOMElement template
      expect(-> Table {element}).toThrow()

    it 'throws if it has other children than rows', ->
      template = """
        <th-table>
          <th-table-row type="cells"></th-table-row>
          <div></div>
        </th-table>
      """
      element = createDOMElement template
      expect(-> Table {element}).toThrow()

    it 'throws if it has improperly defined rows', ->
      template = """
        <th-table>
          <th-table-row></th-table-row>
        </th-table>
      """
      element = createDOMElement template
      expect(-> Table {element}).toThrow()

    it 'works if properly defined', ->
      template = """
        <th-table>
          <th-table-row type="cells"></th-table-row>
        </th-table>
      """
      element = createDOMElement template
      expect(-> Table {element}).not.toThrow()

  describe '#clear', ->
    it 'empties the element passed to Table', ->
      template = """
        <th-table>
          <th-table-row type="cells"></th-table-row>
        </th-table>
      """
      element = createDOMElement template
      table = Table {element}
      table.clear()
      expect(element.children.length).toBe 0

  describe '#generateTableTemplate', ->
    it 'throws unless a delegate has been previously set', ->
      template = """
        <th-table>
          <th-table-row type="cells"></th-table-row>
        </th-table>
      """
      element = createDOMElement template
      table = Table {element}
      expect(-> table.generateTableTemplate()).toThrow()

    it 'calls generateTableTemplate on the delegate', ->
      template = """
        <th-table>
          <th-table-row type="cells"></th-table-row>
        </th-table>
      """
      element = createDOMElement template
      table = Table {element}

      fetchData = -> return
      delegate = SimpleTableDelegate {fetchData}
      table.setDelegate delegate

      tableTemplate = table.generateTableTemplate()
      node = createDOMElement tableTemplate
      expect(node.getElementsByTagName('table').length).toBe 1
