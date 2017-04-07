import { CssFrameworkClasses } from "./thGrid.interfaces";

const bootstrapCssClasses: CssFrameworkClasses = {
  row: {
    row: "row",
    noGutters: "no-gutters",
    alignment: {
      centre: "justify-content-center",
      left: "justify-content-start",
      right: "justify-content-end",
      vcentre: "align-items-center",
    },
  },
  column: {
    column: "col",
    columnsLg: "col-lg-xx",
    columnsMd: "col-md-xx",
    columnsSm: "col-sm-xx",
    columnsXs: "col-xx",

    hideLg: "hidden-lg-up",
    hideMd: "hidden-md-up",
    hideSm: "hidden-sm-down",
    hideXs: "hidden-xs-down",
  },
};

export { bootstrapCssClasses };
