/*
  gulpfile.ts
  ===========
  Each task has been broken out into its own file in gulp/tasks.

  To add a new task, simply add a new TypeScript task class file that directory
  and require below.

  HowTo: https://github.com/pleerock/gulpclass

*/

import "./tools/gulp/tasks/Catalog";
import "./tools/gulp/tasks/BrowserSync";
import "./tools/gulp/tasks/Watch";
import "./tools/gulp/tasks/Webpack";
import "./tools/gulp/tasks/Default";
