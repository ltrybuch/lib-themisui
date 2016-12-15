{
  createDOMElement
} = require "spec_helpers"
context = describe

describe 'ThemisComponents: Service: thSimpleTableDelegate', ->
  SimpleTableDelegate = TableHeader = null

  beforeEach angular.mock.module 'ThemisComponents'
  beforeEach inject (_SimpleTableDelegate_, _TableHeader_) ->
    SimpleTableDelegate = _SimpleTableDelegate_
    TableHeader = _TableHeader_

  it 'exists', ->
    expect(SimpleTableDelegate?).toBe true

  it 'throws if there is no cells row', ->
    expect(-> SimpleTableDelegate()).toThrow()

  it 'generates a <table>', ->
    fetchData = -> return
    cellsTemplate = """
      <th-table-row type="cells"></th-table-row>
    """
    cells = createDOMElement cellsTemplate
    rows = {cells}
    delegate = SimpleTableDelegate {fetchData}
    template = delegate.generateTableTemplate rows
    node = createDOMElement template
    expect(node.getElementsByTagName('table').length).toBe 1
    expect(node.getElementsByTagName('tbody').length).toBe 1

  it 'generates headers', ->
    fetchData = -> return
    headers = [TableHeader {name: "First"}]
    cellsTemplate = """
      <th-table-row type="cells"></th-table-row>
    """
    cells = createDOMElement cellsTemplate
    rows = {cells}
    delegate = SimpleTableDelegate {headers, fetchData}
    template = delegate.generateTableTemplate rows
    node = createDOMElement template
    expect(node.getElementsByTagName('thead').length).toBe 1
    expect(node.getElementsByClassName('th-table-sort-icon').length).toBe 1

  it 'generates <col> elements', ->
    fetchData = -> return
    headers = [
      TableHeader {name: "First", width: '50px'}
      TableHeader {name: "second"}
      TableHeader {name: "First", width: '25%'}
    ]
    cellsTemplate = """
      <th-table-row type="cells"></th-table-row>
    """
    cells = createDOMElement cellsTemplate
    rows = {cells}
    delegate = SimpleTableDelegate {headers, fetchData}
    template = delegate.generateTableTemplate rows
    node = createDOMElement template
    cols = node.getElementsByTagName('col')
    expect(cols[0].style.width).toEqual '50px'
    expect(cols[1].style.width).toEqual ''
    expect(cols[2].style.width).toEqual '25%'
    expect(cols.length).toBe 3

  it 'generates cells rows', ->
    fetchData = -> return
    cellsTemplate = """
      <th-table-row type="cells">
        <th-table-cell>
          <span class="find-me">found</span>
        </th-table-cell>
      </th-table-row>
    """
    cells = createDOMElement cellsTemplate
    rows = {cells}
    delegate = SimpleTableDelegate {fetchData}
    template = delegate.generateTableTemplate rows
    node = createDOMElement template
    expect(node.getElementsByClassName('find-me').length).toBe 1

  it  'generates actions rows', ->
    fetchData = -> return
    cellsTemplate = """
      <th-table-row type="cells">
        <th-table-cell></th-table-cell>
      </th-table-row>
    """
    actionsTemplate = """
      <th-table-row type="actions">
        <span class="find-me">found</span>
      </th-table-row>
    """
    cells = createDOMElement cellsTemplate
    actions = createDOMElement actionsTemplate
    rows = {cells, actions}
    delegate = SimpleTableDelegate {fetchData}
    template = delegate.generateTableTemplate rows
    node = createDOMElement template
    expect(node.getElementsByClassName('find-me').length).toBe 1

  it 'generates pagination', ->
    fetchData = -> return
    pageSize = 5
    cellsTemplate = """
      <th-table-row type="cells"></th-table-row>
    """
    cells = createDOMElement cellsTemplate
    rows = {cells}
    delegate = SimpleTableDelegate {fetchData, pageSize}
    template = delegate.generateTableTemplate rows
    node = createDOMElement template
    expect(node.getElementsByClassName('th-table-pagination').length).toBe 1

  it 'generates loading, error and blank states', ->
    fetchData = -> return
    cellsTemplate = """
      <th-table-row type="cells"></th-table-row>
    """
    cells = createDOMElement cellsTemplate
    rows = {cells}
    delegate = SimpleTableDelegate {fetchData}
    template = delegate.generateTableTemplate rows
    node = createDOMElement template
    expect(template.indexOf('th-table-loading')).not.toBe -1
    expect(node.getElementsByTagName('th-error').length).toBe 1
    expect(node.getElementsByClassName('th-table-no-data-row').length).toBe 1

  it 'generates custom blank states', ->
    fetchData = -> return
    cellsTemplate = """
      <th-table-row type="cells"></th-table-row>
    """
    cells = createDOMElement cellsTemplate
    noDataTemplate = """
      <th-table-row type="no-data">
        <div class="custom-blank"></div>
      </th-table-row>
    """
    noData = createDOMElement noDataTemplate
    rows = {cells, 'no-data': noData}
    delegate = SimpleTableDelegate {fetchData}
    template = delegate.generateTableTemplate rows
    node = createDOMElement template
    expect(node.getElementsByClassName('custom-blank').length).toBe 1
