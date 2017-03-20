interface Dictionary {
  [filename: string]: string;
}

interface PackageJson {
  name: string;
  version: string;
  license: string;
  dependencies: Dictionary;
  devDependencies: Dictionary;
}

interface ComponentMeta {
  private?: boolean;
  displayName?: string;
  whitelistLocal?: boolean | number[];
}

interface ComponentExamples {
    name: string;
    html: string;
    coffee: string;
    typescript: string;
    others: Dictionary;
}

interface Component extends ComponentMeta {
  name: string;
  isMarkdownDoc?: boolean;
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
    globalDocs: Component[];
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
