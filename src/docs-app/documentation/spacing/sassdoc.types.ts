interface SassDocLine {
  start: number;
  end: number;
}

interface SassDocContext {
  code?: string;
  line: SassDocLine;
  scope?: string;
  type: string;
  value?: string;
  name: string;
}

interface SassDocExample {
  code: string;
  type: string;
}

interface SassDoc {
  access: string;
  commentRange: SassDocLine;
  context: SassDocContext;
  description: string;
  example: SassDocExample[];
  file: {
    name: string;
    path: string;
  };
  group: string[];
  usedBy: {
    context: SassDocContext;
    description: string;
  };
}

export {
  SassDocExample,
  SassDoc
}
