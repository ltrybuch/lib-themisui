module.exports = ({interpolateStart, interpolateEnd, valueField, multiple}) -> """
<span
  class="th-autocomplete-wrapper"
  ng-class="[
    {condensed: thAutocomplete.condensed},
    {multiple: thAutocomplete.multiple != null}
  ]"
  >
  <i
    ng-if="thAutocomplete.icon"
    class="th-autocomplete-icon fa fa-#{interpolateStart} thAutocomplete.icon #{interpolateEnd}"
    >
  </i>
  <ui-select
    ng-model="thAutocomplete.ngModel"
    reset-search-input="true"
    on-select="thAutocomplete.ngChange()"
    #{multiple}
    >
    <ui-select-choices
      refresh="
        thAutocomplete.delegate.fetchData(
          { searchString: $select.search },
          thAutocomplete.updateData
        )"
      refresh-delay="100"
      position="down"
      >
    </ui-select-choices>

    <ui-select-match
      placeholder="#{interpolateStart} thAutocomplete.placeholder #{interpolateEnd}"
      >
    </ui-select-match>

  </ui-select>
  <input
    type="hidden"
    name="#{interpolateStart} thAutocomplete.name #{interpolateEnd}"
    ng-value="thAutocomplete.ngModel.#{valueField}"
    >
</span>
"""
