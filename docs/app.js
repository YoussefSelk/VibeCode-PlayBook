const navLinks = document.querySelectorAll(".nav-links a");

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) {
        return;
      }

      const id = entry.target.getAttribute("id");

      navLinks.forEach((link) => {
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

document.querySelectorAll("main section[id]").forEach((section) => {
  observer.observe(section);
});
