import FilterSet from "./filters/filterSet.service";

type Callback = () => void;
type dictionary = { [id: string]: any };
type nameValuePair = { name: string; value: any };

interface AutoCompleteFilterType extends FilterType {
  autocompleteOptions?: {
    modelClass: string;
    trackField?: string;
    displayField?: string;
    queryField?: string;
    queryParams?: dictionary;
  };
  placeholder?: string;
}

interface FilterBase {
  fieldIdentifier: string;
  name: string;
  getState: () => FilterState | null;
  getMetadata: () => dictionary;
}

interface FilterBaseOptions {
  fieldIdentifier: string;
  name: string;
  metadata?: any;
}

interface FilterBaseFactory {
  new (options: FilterBaseOptions): FilterBase;
};

interface FilterComponentOptions {
  filterSet: FilterSet;
  initialState?: FilterSetState;
  staticFilters?: FilterType[];
  customFilterTypes?: FilterType[];
}

interface FilterSetFactory {
  new (options: FilterSetOptions): FilterSet;
}

interface FilterSetOptions {
  onFilterChange: Callback;
  onInitialized?: Callback;
};

interface FilterSetState {
  [fieldIdentifier: string]: {
    value: any;
    operator?: string;
  };
}

interface FilterState {
  name: string;
  value: any;
  operator?: string;
}

interface FilterType {
  type: string;
  name: string;
  fieldIdentifier: string;
  metaData?: dictionary;
}

interface InputFilterType extends FilterType {
  placeholder?: string;
}

interface SelectFilterType extends FilterType {
  selectOptions?: nameValuePair[];
  selectOptionsUrl?: string;
  selectOptionsNameField?: string;
  selectOptionsValueField?: string;
  selectOptionsCallback?: (response: any) => nameValuePair[];
  placeholder?: string;
}

export {
  AutoCompleteFilterType,
  Callback,
  FilterBase,
  FilterBaseFactory,
  FilterBaseOptions,
  FilterComponentOptions,
  FilterSetFactory,
  FilterSetOptions,
  FilterSetState,
  FilterState,
  InputFilterType,
  SelectFilterType,
}
