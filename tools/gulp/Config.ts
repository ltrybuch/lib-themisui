import * as path from "path";
const historyApiFallback = require("connect-history-api-fallback");
const root = path.resolve(__dirname, "../../");
const rootSrc = path.join(root, "src");

declare const process: any;

// type declarations
type UIOptions = {
  port: number
};

type GhostOptions = {
  clicks: boolean,
  forms: boolean,
  scroll: boolean
};

let ui: UIOptions | boolean = {
  port: 3001
};

let ghostMode: GhostOptions | boolean = {
  clicks: true,
  forms: true,
  scroll: false
};

if (process.env.PORT) {
  ui = false;
  ghostMode = false;
}

const ConfigObj = {
  browserSync: {
    port: process.env.PORT || 3042,
    server: {
      baseDir: "src/docs-app",
      index: "index.html",
      routes: {
        "/assets": ".tmp/assets",
        "/images": ".tmp/assets/images",
        "/exampleTemplates": "src/docs-app/exampleTemplates",
        "/components": "src/lib",
        "/node_modules/jquery": "node_modules/jquery",
        "/fonts": "src/themes/fonts",
      },
      middleware: [historyApiFallback()]
    },
    files: [
      "./src/docs-app/index.html"
    ],
    ui,
    ghostMode,
    instanceName: "Themis"
  },

  assetPaths: {
    lib: path.join(rootSrc, "lib", "**", "*.{coffee,ts,html,scss}"),
    examples: path.join(rootSrc, "lib", "**", "examples", "**", "*.{coffee,html,ts}"),
    meta: path.join(rootSrc, "lib", "**", "**", "*.{md,json}"),
    docs: path.join(rootSrc, "docs-app", "**", "*.{coffee,ts,html,scss}"),
    docsMeta: path.join(rootSrc, "docs-app", "**", "*.{md,json}"),
    readme: path.join(root, "README.md"),
    theme: path.join(rootSrc, "themes", "**", "*.scss")
  }
};

export { ConfigObj as Config };
