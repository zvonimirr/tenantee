// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
// Include Tippy.js for tooltips
import tippy, { animateFill, roundArrow } from "tippy.js";
// Import hooks
import { FormHook } from "./hooks/form";
import { ModalHook } from "./hooks/modal";
import { CopyHook } from "./hooks/copy";

// Define hooks
const Hooks = {
  FormHook,
  ModalHook,
  CopyHook,
};

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
const liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// Show progress bar on live navigation and form submits
topbar.config({
  barThickness: 8,
  barColors: { 0: "#15803d" },
  shadowColor: "rgba(0, 0, 0, .3)",
});
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// Initialize tooltips
window.addEventListener("phx:page-loading-stop", () => {
  const tooltips = document.querySelectorAll("[data-tooltip]");

  tooltips.forEach((tooltip) => {
    tippy(tooltip, {
      duration: 500,
      content: tooltip.dataset.tooltip,
      arrow: roundArrow,
      plugins: [animateFill],
      placement: "bottom",
    });
  });
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
