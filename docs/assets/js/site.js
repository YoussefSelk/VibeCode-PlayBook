const copyButtons = document.querySelectorAll("[data-copy-target]");
const downloadButtons = document.querySelectorAll("[data-download-target]");
const topNavLinks = document.querySelectorAll(".nav a[data-page]");
const topbar = document.querySelector(".topbar");
const themeStorageKey = "vc-playbook-theme";

const getPreferredTheme = () => {
  const stored = localStorage.getItem(themeStorageKey);
  if (stored === "light" || stored === "dark") {
    return stored;
  }

  return window.matchMedia("(prefers-color-scheme: dark)").matches
    ? "dark"
    : "light";
};

const applyTheme = (theme) => {
  document.documentElement.setAttribute("data-theme", theme);
  const themeMeta = document.querySelector('meta[name="theme-color"]');
  if (themeMeta) {
    themeMeta.setAttribute("content", theme === "dark" ? "#0d141d" : "#0f8b8d");
  }
};

const renderThemeToggle = () => {
  if (!topbar) {
    return;
  }

  const button = document.createElement("button");
  button.type = "button";
  button.className = "btn btn-secondary theme-toggle";

  const updateLabel = () => {
    const mode =
      document.documentElement.getAttribute("data-theme") === "dark"
        ? "dark"
        : "light";
    button.textContent = mode === "dark" ? "Light mode" : "Dark mode";
    button.setAttribute(
      "aria-label",
      `Switch to ${mode === "dark" ? "light" : "dark"} mode`,
    );
  };

  button.addEventListener("click", () => {
    const current =
      document.documentElement.getAttribute("data-theme") === "dark"
        ? "dark"
        : "light";
    const next = current === "dark" ? "light" : "dark";
    localStorage.setItem(themeStorageKey, next);
    applyTheme(next);
    updateLabel();
  });

  topbar.appendChild(button);
  updateLabel();
};

applyTheme(getPreferredTheme());
renderThemeToggle();

const currentPage = document.body.dataset.page;

if (currentPage) {
  topNavLinks.forEach((link) => {
    if (link.dataset.page === currentPage) {
      link.setAttribute("aria-current", "page");
    }
  });
}

const copyText = async (text) => {
  if (navigator.clipboard && window.isSecureContext) {
    await navigator.clipboard.writeText(text);
    return true;
  }

  const area = document.createElement("textarea");
  area.value = text;
  area.style.position = "fixed";
  area.style.opacity = "0";
  document.body.appendChild(area);
  area.focus();
  area.select();

  let ok = false;
  try {
    ok = document.execCommand("copy");
  } finally {
    document.body.removeChild(area);
  }

  return ok;
};

copyButtons.forEach((button) => {
  button.addEventListener("click", async () => {
    const targetId = button.dataset.copyTarget;
    const target = targetId ? document.getElementById(targetId) : null;

    if (!target) {
      return;
    }

    const text = target.textContent ?? "";
    const original = button.textContent;

    try {
      const ok = await copyText(text);
      button.textContent = ok ? "Copied" : "Copy failed";
    } catch (error) {
      button.textContent = "Copy failed";
    }

    window.setTimeout(() => {
      button.textContent = original;
    }, 1400);
  });
});

downloadButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const targetId = button.dataset.downloadTarget;
    const target = targetId ? document.getElementById(targetId) : null;

    if (!target) {
      return;
    }

    const text = target.textContent ?? "";
    const filename = button.dataset.downloadName || "generated-output.txt";
    const blob = new Blob([text], { type: "text/plain;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = filename;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
  });
});
