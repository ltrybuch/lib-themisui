interface ScssVariables {
  [id: string]: string;
};

interface ColorData {
  variable: string;
  hex: string;
};

type variableFilterCallback = (variable: string) => boolean;

export {ScssVariables, ColorData, variableFilterCallback};
