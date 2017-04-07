type alignmentOptions = "left" | "right" | "vcentre";

interface CssFrameworkClasses {
  row: {
    row: string;
    gutters?: string;
    noGutters?: string;
    alignment: AlignmentClasses;
  };
  column: {
    column: string;
    columnsLg: string;
    columnsMd: string;
    columnsSm: string;
    columnsXs: string;
    hideLg: string;
    hideMd: string;
    hideSm: string;
    hideXs: string;
  };
}

interface AlignmentClasses {
  centre?: string;
  left: string;
  right: string;
  vcentre: string;
  [alignment: string]: string;
};

interface RowConfig {
  hideGutters?: boolean;
  align?: alignmentOptions;
}

interface ColumnConfig {
  columns: string;
  columnsLg?: string;
  columnsSm?: string;
  columnsXs?: string;
  hideLg?: boolean;
  hideMd?: boolean;
  hideSm?: boolean;
  hideXs?: boolean;
}

export {
  AlignmentClasses,
  alignmentOptions,
  CssFrameworkClasses,
  RowConfig,
  ColumnConfig
}
