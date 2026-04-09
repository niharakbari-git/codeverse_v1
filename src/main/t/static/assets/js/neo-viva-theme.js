(function () {
	function applyThemeClasses() {
		if (document.documentElement) {
			document.documentElement.classList.add("cv-theme-root");
		}
		if (document.body) {
			document.body.classList.add("cv-theme");
		}
	}

	function normalizeActionLabels() {
		var roleBadges = document.querySelectorAll(".role");
		roleBadges.forEach(function (el) {
			var text = (el.textContent || "").trim().toUpperCase();
			if (text === "LEADER") {
				el.textContent = "TEAM LEADER";
			}
			if (text === "MEMBER") {
				el.textContent = "TEAM MEMBER";
			}
		});
	}

	function init() {
		applyThemeClasses();
		normalizeActionLabels();
	}

	if (document.readyState === "loading") {
		document.addEventListener("DOMContentLoaded", init);
	} else {
		init();
	}
})();
