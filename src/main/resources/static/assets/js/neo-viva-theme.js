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
    initUrlActions();
  });

  function normalizeUrlValue(value) {
    if (!value) {
      return "";
    }
    var trimmed = value.trim();
    if (/^https?:\/\//i.test(trimmed)) {
      return trimmed;
    }
    return "https://" + trimmed;
  }

  function initUrlActions() {
    document.querySelectorAll(".url-input-group").forEach(function (group) {
      var input = group.querySelector("input");
      var copyBtn = group.querySelector(".copy-url");
      var openBtn = group.querySelector(".open-url");
      var feedback = group.querySelector(".url-feedback");
      if (!input || !copyBtn || !openBtn) {
        return;
      }

      function refreshButtons() {
        var value = input.value.trim();
        var hasValue = value.length > 0;
        copyBtn.hidden = !hasValue;
        openBtn.hidden = !hasValue;
        group.classList.toggle("has-url", hasValue);
      }

      function showFeedback(message) {
        if (!feedback) {
          return;
        }
        feedback.textContent = message;
        feedback.classList.add("show");
        window.clearTimeout(feedback._timer);
        feedback._timer = window.setTimeout(function () {
          feedback.classList.remove("show");
        }, 1800);
      }

      refreshButtons();
      input.addEventListener("input", refreshButtons);

      copyBtn.addEventListener("click", function () {
        var text = input.value.trim();
        if (!text) {
          return;
        }
        navigator.clipboard.writeText(text).then(function () {
          showFeedback("Copied!");
        }, function () {
          showFeedback("Copy failed");
        });
      });

      openBtn.addEventListener("click", function () {
        var url = normalizeUrlValue(input.value);
        if (!url) {
          return;
        }
        window.open(url, "_blank");
      });
    });

    document.querySelectorAll(".url-action-btn[data-url]").forEach(function (button) {
      button.addEventListener("click", function () {
        var url = button.getAttribute("data-url");
        if (!url) {
          return;
        }
        if (button.classList.contains("copy-url")) {
          navigator.clipboard.writeText(url).then(function () {
            button.title = "Copied!";
            window.setTimeout(function () {
              button.title = button.getAttribute("data-tooltip") || "Copy link";
            }, 1400);
          });
        }
        if (button.classList.contains("open-url")) {
          window.open(normalizeUrlValue(url), "_blank");
        }
      });

      var url = button.getAttribute("data-url");
      if (!url) {
        button.hidden = true;
      }
    });
  }
})();
