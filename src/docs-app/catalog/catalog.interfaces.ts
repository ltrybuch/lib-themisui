interface Dictionary {
  [filename: string]: string;
}

interface PackageJson {
  name: string;
  version: string;
  license: string;
}

interface ComponentMeta {
  private: boolean;
  prettyName?: string;
  whitelistLocal?: boolean | number[];
}

interface ComponentExamples {
    name: string;
    html: string;
    coffee: string;
    others: Dictionary;
}

interface Component extends ComponentMeta {
  name: string;
  readme: Readme;
  examples: ComponentExamples[];
}

interface Readme {
  markdown: string;
  html: string;
}

interface Catalog {
    name: string;
    version: string;
    license: string;
    components: Component[];
    docs: Component[];
}

export {
  Dictionary,
  PackageJson,
  Readme,
  Catalog,
  Component,
  ComponentMeta,
  ComponentExamples
}
