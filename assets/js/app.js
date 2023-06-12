// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";
// Include Tippy.js for tooltips
import tippy from "tippy.js";
import "tippy.js/dist/tippy.css";

const csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
const liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// Initialize tooltips
const tooltips = Array.from(document.querySelectorAll("[data-tooltip]")).map(
  (el) => el.dataset.tooltip
);

tooltips.forEach((tooltip) => {
  tippy(`[data-tooltip='${tooltip}']`, {
    allowHTML: true,
    duration: 0,
    content: `<div class="bg-gray-800 text-white text-sm rounded-lg p-2">${tooltip}</div>`,
  });
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
