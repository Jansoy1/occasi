/* ════════════════════════════════════════════════
   Occasi UI helpers — replace alert/confirm with
   styled toasts and modals.
   ════════════════════════════════════════════════ */

(function() {
  /* Ensure toast host exists */
  function getToastHost() {
    var h = document.getElementById("toastHost");
    if (!h) {
      h = document.createElement("div");
      h.id = "toastHost";
      document.body.appendChild(h);
    }
    return h;
  }

  /* Ensure modal host exists */
  function getModalHost() {
    var h = document.getElementById("occasiModalHost");
    if (!h) {
      h = document.createElement("div");
      h.id = "occasiModalHost";
      h.className = "modal-bg";
      h.innerHTML = '<div class="modal-window">' +
        '<div class="modal-icon" id="omIcon"></div>' +
        '<div class="modal-title" id="omTitle"></div>' +
        '<div class="modal-msg" id="omMsg"></div>' +
        '<div class="modal-actions" id="omActions"></div>' +
      '</div>';
      document.body.appendChild(h);
      h.addEventListener("click", function(e) {
        if (e.target === h) closeModal();
      });
    }
    return h;
  }

  function closeModal() {
    var h = document.getElementById("occasiModalHost");
    if (h) h.classList.remove("show");
  }

  /* PUBLIC: showToast(message, options)
     options: { title, type: 'success'|'error'|'info', duration: ms } */
  window.showToast = function(message, opts) {
    opts = opts || {};
    var type = opts.type || "info";
    var duration = opts.duration || 4000;
    var icons = { success: "✓", error: "!", info: "i" };
    var titles = opts.title || (type === "success" ? "Success" : type === "error" ? "Heads up" : "Info");

    var host = getToastHost();
    var t = document.createElement("div");
    t.className = "toast " + type;
    t.innerHTML =
      '<div class="toast-ico">' + (icons[type] || "i") + '</div>' +
      '<div class="toast-content">' +
        '<div class="toast-title">' + escapeHtml(titles) + '</div>' +
        '<div class="toast-msg">' + escapeHtml(message) + '</div>' +
      '</div>' +
      '<button class="toast-close" aria-label="Dismiss">×</button>';
    host.appendChild(t);

    var dismiss = function() {
      t.classList.add("out");
      setTimeout(function() { if (t.parentNode) t.parentNode.removeChild(t); }, 250);
    };
    t.querySelector(".toast-close").addEventListener("click", dismiss);
    if (duration > 0) setTimeout(dismiss, duration);
  };

  /* PUBLIC: showSuccess(msg, title?) */
  window.showSuccess = function(msg, title) {
    showToast(msg, { type: "success", title: title || "Success" });
  };

  /* PUBLIC: showError(msg, title?) */
  window.showError = function(msg, title) {
    showToast(msg, { type: "error", title: title || "Error", duration: 6000 });
  };

  /* PUBLIC: showInfo(msg, title?) */
  window.showInfo = function(msg, title) {
    showToast(msg, { type: "info", title: title || "Info" });
  };

  /* PUBLIC: showModal({title, message, type, buttons}) returns Promise<value or null> */
  window.showModal = function(opts) {
    return new Promise(function(resolve) {
      var host = getModalHost();
      var iconEl = document.getElementById("omIcon");
      var titleEl = document.getElementById("omTitle");
      var msgEl = document.getElementById("omMsg");
      var actionsEl = document.getElementById("omActions");

      var iconText = { success: "✓", warn: "!", info: "i", error: "✕" };
      iconEl.className = "modal-icon " + (opts.type || "info");
      iconEl.textContent = iconText[opts.type || "info"] || "i";
      titleEl.textContent = opts.title || "";
      msgEl.textContent = opts.message || "";

      actionsEl.innerHTML = "";
      var buttons = opts.buttons || [
        { label: "OK", value: true, primary: true }
      ];
      buttons.forEach(function(b) {
        var btn = document.createElement("button");
        btn.className = "modal-btn " + (b.primary ? "modal-btn-primary" : "modal-btn-secondary");
        btn.textContent = b.label;
        btn.addEventListener("click", function() {
          closeModal();
          resolve(b.value);
        });
        actionsEl.appendChild(btn);
      });

      host.classList.add("show");
    });
  };

  /* PUBLIC: showConfirm(message, title?) — returns Promise<boolean> */
  window.showConfirm = function(message, title) {
    return showModal({
      type: "warn",
      title: title || "Are you sure?",
      message: message,
      buttons: [
        { label: "Cancel", value: false, primary: false },
        { label: "Confirm", value: true, primary: true }
      ]
    });
  };

  /* PUBLIC: showAlert(message, title?, type?) — returns Promise (just for awaitability) */
  window.showAlert = function(message, title, type) {
    return showModal({
      type: type || "info",
      title: title || "",
      message: message,
      buttons: [{ label: "OK", value: true, primary: true }]
    });
  };

  function escapeHtml(s) {
    return String(s).replace(/[&<>"']/g, function(c) {
      return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c];
    });
  }
})();
