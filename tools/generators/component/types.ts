type fileInfo = {
  path: string;
  content: string;
};

type characterLimits = {
  charLimit: number;
  displayCharLimit: number;
};

type documentationOptions = {
  docType: "Top level" | "Design" | "Development";
  documentationName: string;
  displayName?: string;
  docFunctionality?: false | string[];
};

export {
  characterLimits,
  documentationOptions,
  fileInfo,
}
