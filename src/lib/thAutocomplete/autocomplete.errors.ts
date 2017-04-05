class AutocompleteError extends Error {
  constructor(name: string, message: string) {
    super(message);
    this.name = `th-autocomplete: ${name}`;
  }
}

class AutocompleteProviderError extends AutocompleteError {
  constructor(message: string) {
    super("Provider", message);
  }
}

class AutocompleteComponentError extends AutocompleteError {
  constructor(message: string) {
    super("Component", message);
  }
}

export {
  AutocompleteProviderError,
  AutocompleteComponentError
}
