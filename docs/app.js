const navLinks = document.querySelectorAll(".nav-links a");
const sidebarLinks = document.querySelectorAll(".sidebar-nav a");
const sections = document.querySelectorAll(".docs-main > [id]");
const revealBlocks = document.querySelectorAll(".reveal");
const tabButtons = document.querySelectorAll(".tab-button");
const installPanels = document.querySelectorAll(".install-panel");
const filterButtons = document.querySelectorAll(".filter-chip");
const assistantButtons = document.querySelectorAll(".assistant-chip");
const roleChips = document.querySelectorAll(".role-chip");
const copyButtons = document.querySelectorAll("[data-copy]");
const toast = document.getElementById("toast");
const powershellBlock = document.getElementById("powershell-block");
const bashBlock = document.getElementById("bash-block");
const assistantLabelPs = document.getElementById("assistant-label-ps");
const assistantLabelBash = document.getElementById("assistant-label-bash");

const assistantLabels = {
  codex: "Codex",
  claude: "Claude",
  github: "GitHub Copilot",
};

let selectedAssistant = "codex";

const buildCommands = (assistant) => ({
  powershell: `iex "& { $(irm https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.ps1) } -Assistant ${assistant}"`,
  bash: `curl -fsSL https://raw.githubusercontent.com/YoussefSelk/VibeCode-PlayBook/main/scripts/install.sh | bash -s -- --assistant ${assistant}`,
});

const copyMap = {
  prompt: document.getElementById("prompt-block")?.textContent ?? "",
  powershell: "",
  bash: "",
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

const renderAssistantCommands = () => {
  const commands = buildCommands(selectedAssistant);
  copyMap.powershell = commands.powershell;
  copyMap.bash = commands.bash;

  if (powershellBlock) {
    powershellBlock.textContent = commands.powershell;
  }

  if (bashBlock) {
    bashBlock.textContent = commands.bash;
  }

  if (assistantLabelPs) {
    assistantLabelPs.textContent = assistantLabels[selectedAssistant];
  }

  if (assistantLabelBash) {
    assistantLabelBash.textContent = assistantLabels[selectedAssistant];
  }
};

const setActiveNav = (id) => {
  [...navLinks, ...sidebarLinks].forEach((link) => {
    const active = link.getAttribute("href") === `#${id}`;
    link.dataset.active = active ? "true" : "false";

    if (active) {
      link.setAttribute("aria-current", "location");
      return;
    }

    link.removeAttribute("aria-current");
  });
};

if ("IntersectionObserver" in window) {
  const navObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting) {
          return;
        }

        const id = entry.target.getAttribute("id");
        if (id) {
          setActiveNav(id);
        }
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
} else {
  setActiveNav("top");
  revealBlocks.forEach((block) => {
    block.classList.add("is-visible");
  });
}

tabButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const selectedTab = button.dataset.tab;

    tabButtons.forEach((candidate) => {
      const active = candidate === button;
      candidate.classList.toggle("is-active", active);
      candidate.setAttribute("aria-selected", active ? "true" : "false");
      candidate.setAttribute("tabindex", active ? "0" : "-1");
    });

    installPanels.forEach((panel) => {
      const active = panel.dataset.panel === selectedTab;
      panel.classList.toggle("is-active", active);
      panel.hidden = !active;
    });
  });
});

filterButtons.forEach((button) => {
  button.addEventListener("click", () => {
    if (button.dataset.assistant) {
      return;
    }

    const selectedFilter = button.dataset.filter;

    filterButtons.forEach((candidate) => {
      if (candidate.dataset.assistant) {
        return;
      }

      const active = candidate === button;
      candidate.classList.toggle("is-active", active);
      candidate.setAttribute("aria-pressed", active ? "true" : "false");
    });

    roleChips.forEach((chip) => {
      const groups = (chip.dataset.roleGroup ?? "").split(" ");
      const matches =
        selectedFilter === "all" || groups.includes(selectedFilter);

      chip.classList.toggle("is-dimmed", !matches);
    });
  });
});

assistantButtons.forEach((button) => {
  button.addEventListener("click", () => {
    selectedAssistant = button.dataset.assistant ?? "codex";

    assistantButtons.forEach((candidate) => {
      const active = candidate === button;
      candidate.classList.toggle("is-active", active);
      candidate.setAttribute("aria-pressed", active ? "true" : "false");
    });

    renderAssistantCommands();
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

renderAssistantCommands();
setActiveNav("top");
