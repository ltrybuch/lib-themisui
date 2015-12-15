// Patch for jQuery that lets 'type' attributes to be set if the browser allows it.
// ex: <th-button type="standard">name<th-button>
// This was only relevant for IE 8 and below which we do not support anyhow.
// https://github.com/jquery/jquery/commit/aad235b3251494afe71fd5bb6031e11965af9bdb

if(typeof jQuery == 'function' || typeof $ == 'function') {
  if (/1\.(7|8)\.\d/.test(jQuery.fn.jquery)) {
    jQuery.extend({
      attrHooks: {
        type: {
          set: function( elem, value ) {
              // Setting the type on a radio button after the value resets the value in IE6-9
              // Reset value to it's default in case type is set after value
              // This is for element creation
            if ( !jQuery.support.radioValue && value === "radio" && jQuery.nodeName(elem, "input") ) {
            // Reset value to default in case type is set after value during creation
              var val = elem.value;
              elem.setAttribute( "type", value );
              if ( val ) {
                elem.value = val;
              }
              return value;
            }
          }
        }
      }
    });
  }
}
