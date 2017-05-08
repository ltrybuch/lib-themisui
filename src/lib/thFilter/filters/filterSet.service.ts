import { FilterSetState, FilterSetOptions, FilterBase, Callback } from "../thFilter.interface";
const debounce = require("debounce") as (fn: Function, timeout: number) => Callback;
type filterSetFindPredicate = (value: FilterBase, index: number, obj: FilterBase[]) => boolean;

class FilterSet {
  static timeout = 300;
  static dataSourceOperatorMap: { [operator: string]: string; } = {
    "<": "lt",
    "<=": "lte",
    "=": "eq",
    ">=": "gte",
    ">": "gt",
  };

  private filterSetArray: FilterBase[] = [];
  onFilterChange: Callback;
  onInitialized: Callback;

  constructor(options: FilterSetOptions) {
    this.validateOptions(options);
  }

  get length() {
    return this.filterSetArray.length;
  }

  get(index: number) {
    return this.filterSetArray[index];
  }

  push(...items: FilterBase[]) {
    return this.filterSetArray.push(...items);
  }

  find(predicate: filterSetFindPredicate, thisArg?: any) {
    return this.filterSetArray.find(predicate, thisArg || this.filterSetArray);
  }

  remove(filterBase: FilterBase) {
    const index = this.filterSetArray.indexOf(filterBase);
    if (index >= 0) {
      this.filterSetArray.splice(index, 1);
    } else {
      throw new Error("Filter to be removed not found.");
    }
  }

  getState(): FilterSetState {
    return this.filterSetArray.reduce((paramsCollector, filter: FilterBase) => {
      const state = filter.getState();
      if (state) {
        return { ...paramsCollector, [filter.fieldIdentifier]: state };
      } else {
        return paramsCollector;
      }
    }, {});
  }

  getDataSourceState() {
    const filterState = this.getState();
    return Object.keys(filterState).map(key => {
      const filterOperator = filterState[key].operator;
      const currentFilter = {
        field: key,
        operator: FilterSet.dataSourceOperatorMap[filterOperator] || "eq",
        value: filterState[key].value,
      };

      return currentFilter;
    });
  }

  getMetadata(): { [id: string]: any } {
    return this.filterSetArray.reduce((paramsCollector, filter: FilterBase) => {
      const metaData = filter.getMetadata();
      if (metaData) {
        return { ...paramsCollector, [filter.fieldIdentifier]: metaData };
      } else {
        return paramsCollector;
      }
    }, {});
  }

  private validateOptions(options: FilterSetOptions) {
      const { onFilterChange, onInitialized } = options;

      if (onFilterChange instanceof Function === false) {
        throw new Error("FilterSet needs to be passed the following function: onFilterChange: () =>");
      }

      this.onFilterChange = debounce(onFilterChange, FilterSet.timeout);
      this.onInitialized = onInitialized;
  }
}

export default FilterSet;
