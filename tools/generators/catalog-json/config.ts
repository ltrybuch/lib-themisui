import * as path from "path";
const rootSrc = path.join(path.resolve(__dirname, "../../../"), "src");

const Config = {
  paths: {
    components: path.join(rootSrc, "lib"),
    documentation: path.join(rootSrc, "docs-app", "documentation"),
  },
  outputFiles: {
    catalogJson: path.join(rootSrc, "docs-app", "catalog", "catalog.json"),
  },
};

export default Config;
