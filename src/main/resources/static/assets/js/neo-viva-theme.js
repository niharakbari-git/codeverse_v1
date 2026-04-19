(function () {
  "use strict";

  function normalizeRoleLabels() {
    var roleBackgrounds = {
      "ORGANIZER": "#e8f5f4",
      "ADMIN": "#eef4ff",
      "JUDGE": "#fff7e8"
    };

    var nodes = document.querySelectorAll(".role, .status, .neo-badge");
    nodes.forEach(function (node) {
      var t = (node.textContent || "").trim().toUpperCase();
      if (roleBackgrounds[t]) {
        node.style.background = roleBackgrounds[t];
      }
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    normalizeRoleLabels();
  });
})();
