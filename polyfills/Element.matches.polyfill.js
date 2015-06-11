this.Element && function(ElementPrototype) {
	ElementPrototype.matches = ElementPrototype.matches ||
		ElementPrototype.matchesSelector ||
		ElementPrototype.mozMatchesSelector ||
		ElementPrototype.msMatchesSelector ||
		ElementPrototype.oMatchesSelector ||
		ElementPrototype.webkitMatchesSelector ||
		function (selector) {
			var element = this;
			var matches = (element.document || element.ownerDocument).querySelectorAll(selector);
			var i = 0;

			while (matches[i] && matches[i] !== element) {
				i++;
			}

			return matches[i] ? true : false;
		}
}(Element.prototype);
