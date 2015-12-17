context = describe
describe 'ThemisComponents: Service: thSimpleTableDelegate', ->
  SimpleTableDelegate = TableHeader = null

  createDOMElement = (template) ->
    div = document.createElement 'div'
    div.innerHTML = template
    div.firstChild

  beforeEach ->
    module 'ThemisComponents'

    inject (_SimpleTableDelegate_, _TableHeader_) ->
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
    expect(node.getElementsByClassName('th-table-error').length).toBe 1
    expect(node.getElementsByClassName('th-table-no-data').length).toBe 1

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
