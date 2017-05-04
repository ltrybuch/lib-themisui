import * as UserInput from "./component/user-input";
import generateComponent from "./component/generate-component";
import generateDocumentation from "./component/generate-documentation";
const figlet = require("figlet");

const logo = figlet.textSync("ThemisUI Generator", { kerning: "fitted" });
const generatorMode = ["Component", "Documentation"];
const documentationType = ["Top level", "Design", "Development"];
const documentationFunctionality = ["Markdown", "CSS"];
const characterLimits = {
  charLimit: 20,
  displayCharLimit: 30,
};

/**
 * Start the generator
 */
console.log(logo);
generate();

async function generate() {
  const { mode } = await UserInput.chooseMode(generatorMode);

  if (mode === "Documentation") {
    const { docType } = await UserInput.chooseDocumentationType(documentationType);
    const { documentationName } = await UserInput.inputName(characterLimits, mode);

    if (docType === "Top level") {
      return generateDocumentation({ docType, documentationName });
    }

    const { displayName } = await UserInput.inputName(characterLimits, null, true);
    const { customDoc }  = await UserInput.chooseCustomDoc();
    const { docFunctionality } = customDoc
      ? await UserInput.chooseDocFunctionality(documentationFunctionality)
      : { docFunctionality: false };
    return generateDocumentation({ docType, displayName, documentationName, docFunctionality });

  } else if (mode === "Component") {
    const { componentName } = await UserInput.inputName(characterLimits, mode);
    return generateComponent(componentName);
  }
}
