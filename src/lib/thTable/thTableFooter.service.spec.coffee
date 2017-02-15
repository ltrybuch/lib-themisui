context = describe
describe "ThemisComponents: Service: thTableFooter", ->
  TableFooter = null

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject (_TableFooter_) ->
    TableFooter = _TableFooter_

  it "exists", ->
    expect(TableFooter?).toBe true

  describe '#constructor', ->
    value = 1

    it "throws if incorrect align is provided", ->
      align = "wrong"
      expect(-> TableFooter {align}).toThrow()

    it "exposes value", ->
      footer = TableFooter {value}
      expect(footer.value).toEqual value

  describe "#AlignCssClass", ->
    it "defaults the align left", ->
      footer = TableFooter()
      klass = footer.AlignCssClass()
      expect(klass).toBe "th-table-align-left"

    context "align is right or center", ->

      it "has the proper align class", ->
        footer = TableFooter {align: "right"}
        klass = footer.AlignCssClass()
        expect(klass).toBe "th-table-align-right"

        footer = TableFooter {align: "center"}
        klass = footer.AlignCssClass()
        expect(klass).toBe "th-table-align-center"
