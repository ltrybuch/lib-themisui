function capitalizeFirstLetter(theStr: string): string {
    return theStr.charAt(0).toUpperCase() + theStr.slice(1);
}

/**
 * @desc Converts a camelCase filename to a display name, dropping any extension
 * ex: "myFileName.txt" becomes "My File Name"
 * @param theStr string
 */
function camelToDisplayName(theStr: string): string {
  let result = theStr.replace(/([A-Z])/g, " $1" ).replace(/\..+/, "");
  result = result.charAt(0).toUpperCase() + result.slice(1);
  return result;
}

function getUrlSlug(theStr: string) {
  return theStr
          .replace(/([A-Z])/g, "-$1" ) // Convert camelCase to kebab
          .toLowerCase()
          .replace(/\..+/, "")         // Remove extension
          .replace(/\s+/g, "-")        // Replace spaces with -
          .replace(/[^\w\-]+/g, "")    // Remove all non-word chars
          .replace(/\-\-+/g, "-")      // Replace multiple - with single -
          .replace(/^-+/, "")          // Trim - from start of text
          .replace(/-+$/, "");         // Trim - from end of text

}

export {
  capitalizeFirstLetter,
  camelToDisplayName,
  getUrlSlug,
}
