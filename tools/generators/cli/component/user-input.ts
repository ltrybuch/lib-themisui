import * as inquirer from "inquirer";
import * as types from "./types";
import * as Utilities from "./utilities";

function chooseMode(generatorMode: string[]) {
  return inquirer.prompt({
    name: "mode",
    type: "list",
    message: "What would you like to generate?",
    choices: generatorMode,
  });
}

function chooseDocumentationType(documentationType: string[]) {
  return inquirer.prompt({
    name: "docType",
    type: "list",
    message: "What type of documentation?",
    choices: documentationType,
  });
}

function chooseCustomDoc() {
  return inquirer.prompt({
    name: "customDoc",
    type: "confirm",
    message: "Do you need JavaScript to write this documentation?",
  });
}

function chooseDocFunctionality(documentationFunctionality: string[]) {
  return inquirer.prompt({
    name: "docFunctionality",
    type: "checkbox",
    message: "What else do you need boss?",
    choices: documentationFunctionality,
    default: documentationFunctionality,
  });
}

function inputName(
  { displayCharLimit, charLimit }: types.characterLimits,
  mode: "Documentation" | "Component",
  display?: boolean,
) {
  const displayNameMessage = "If needed, you may provide a display name (Enter for none):";
  const message = mode === "Component"
    ? "Give your component a name without the th prefix (ex. Data Grid):"
    : "Give your documentation a short name (ex. Color Palette):";
  const name = display ? "displayName" : `${mode.toLowerCase()}Name`;
  const checkLength = (input: string, limit: number) => (input && input.length > limit)
    ? `Please limit the name to ${limit} characters.`
    : true;

  return inquirer.prompt({
    name,
    message: display ? displayNameMessage : message,
    validate: input => {
      if (display) {
        return checkLength(input, displayCharLimit);
      } else if (input && input.length) {
        if (Utilities.isDirty(input)) {
          return `Special characters are not allowed.`;
        }
        return checkLength(input, charLimit);
      } else {
        return `Please provide your ${mode.toLowerCase()} a name.`;
      }
    },
  });
}

export {
  chooseCustomDoc,
  chooseDocFunctionality,
  chooseDocumentationType,
  chooseMode,
  inputName,
}
