const navLinks = document.querySelectorAll(".nav-links a");
const sidebarLinks = document.querySelectorAll(".sidebar-nav a");
const sections = document.querySelectorAll("main section[id]");
const revealBlocks = document.querySelectorAll(".reveal");
const tabButtons = document.querySelectorAll(".tab-button");
const installPanels = document.querySelectorAll(".install-panel");
const filterButtons = document.querySelectorAll(".filter-chip");
const roleChips = document.querySelectorAll(".role-chip");
const copyButtons = document.querySelectorAll("[data-copy]");
const toast = document.getElementById("toast");

const copyMap = {
  prompt: document.getElementById("prompt-block")?.textContent ?? "",
  powershell: document.getElementById("powershell-block")?.textContent ?? "",
  bash: document.getElementById("bash-block")?.textContent ?? "",
};

let toastTimer;

const legacyCopy = (text) => {
  const textarea = document.createElement("textarea");
  textarea.value = text;
  textarea.setAttribute("readonly", "");
  textarea.style.position = "fixed";
  textarea.style.opacity = "0";
  textarea.style.pointerEvents = "none";
  document.body.appendChild(textarea);
  textarea.focus();
  textarea.select();

  let copied = false;

  try {
    copied = document.execCommand("copy");
  } catch (error) {
    copied = false;
  }

  document.body.removeChild(textarea);
  return copied;
};

const showToast = (message) => {
  if (!toast) {
    return;
  }

  toast.textContent = message;
  toast.classList.add("is-visible");
  clearTimeout(toastTimer);
  toastTimer = window.setTimeout(() => {
    toast.classList.remove("is-visible");
  }, 1800);
};

const navObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) {
        return;
      }

      const id = entry.target.getAttribute("id");

      [...navLinks, ...sidebarLinks].forEach((link) => {
        const active = link.getAttribute("href") === `#${id}`;
        link.dataset.active = active ? "true" : "false";
        link.setAttribute("aria-current", active ? "location" : "false");
      });
    });
  },
  {
    threshold: 0.35,
    rootMargin: "-10% 0px -40% 0px",
  }
);

sections.forEach((section) => {
  navObserver.observe(section);
});

const revealObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) {
        return;
      }

      entry.target.classList.add("is-visible");
      revealObserver.unobserve(entry.target);
    });
  },
  {
    threshold: 0.14,
  }
);

revealBlocks.forEach((block, index) => {
  block.style.transitionDelay = `${Math.min(index * 45, 220)}ms`;
  revealObserver.observe(block);
});

tabButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const selectedTab = button.dataset.tab;

    tabButtons.forEach((candidate) => {
      const active = candidate === button;
      candidate.classList.toggle("is-active", active);
      candidate.setAttribute("aria-selected", active ? "true" : "false");
    });

    installPanels.forEach((panel) => {
      panel.classList.toggle("is-active", panel.dataset.panel === selectedTab);
    });
  });
});

filterButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const selectedFilter = button.dataset.filter;

    filterButtons.forEach((candidate) => {
      candidate.classList.toggle("is-active", candidate === button);
    });

    roleChips.forEach((chip) => {
      const groups = (chip.dataset.roleGroup ?? "").split(" ");
      const matches =
        selectedFilter === "all" || groups.includes(selectedFilter);

      chip.classList.toggle("is-dimmed", !matches);
    });
  });
});

copyButtons.forEach((button) => {
  button.addEventListener("click", async () => {
    const key = button.dataset.copy;
    const text = copyMap[key];

    if (!text) {
      showToast("Nothing to copy.");
      return;
    }

    try {
      if (navigator.clipboard && window.isSecureContext) {
        await navigator.clipboard.writeText(text);
        showToast("Copied to clipboard.");
        return;
      }

      if (legacyCopy(text)) {
        showToast("Copied to clipboard.");
        return;
      }

      showToast("Select and copy manually.");
    } catch (error) {
      if (legacyCopy(text)) {
        showToast("Copied to clipboard.");
        return;
      }

      showToast("Select and copy manually.");
    }
  });
});
