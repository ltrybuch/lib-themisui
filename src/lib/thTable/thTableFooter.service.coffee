angular.module "ThemisComponents"
  .factory "TableFooter", -> TableFooter

TableFooter = (options = {}) ->
  {value = "-", align = "left", visible = true} = options

  if align not in ["left", "center", "right"]
    throw new Error "align can be one of: left, center, or right."

  return {
    value
    visible
    AlignCssClass: -> return "th-table-align-#{align}"
  }
