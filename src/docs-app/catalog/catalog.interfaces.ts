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
  section?: boolean;
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
  displayName: string;
  isMarkdownDoc?: boolean;
  readme: Readme;
  urlSlug: string;
  examples: ComponentExamples[];
}

interface MarkdownDoc extends ComponentMeta {
  name: string;
  displayName: string;
  readme: Readme;
  urlSlug: string;
  isMarkdownDoc: boolean;
}

interface Section extends ComponentMeta {
  displayName: string;
  name: string;
  collapsed?: boolean;
  docs?: MarkdownDoc[];
}

interface Readme {
  markdown?: string;
  html?: string;
}

interface Catalog {
  name: string;
  version: string;
  license: string;
  components: Component[];
  docs: Component[];
  globalDocs: MarkdownDoc[];
}

export {
  Dictionary,
  PackageJson,
  Readme,
  Catalog,
  Component,
  ComponentMeta,
  ComponentExamples,
  MarkdownDoc,
  Section
}
