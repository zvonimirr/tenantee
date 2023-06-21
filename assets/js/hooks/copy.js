export const CopyHook = {
  mounted() {
    // Get all elements with the data-copy attribute
    const elements = this.el.querySelectorAll("[data-copy]");
    elements.forEach((element) => {
      element.addEventListener("click", () => {
        // Disable the button
        element.setAttribute("disabled", "disabled");
        // Get the value of the data-value attribute
        const value = element.getAttribute("data-value");

        // Copy the value to the clipboard
        navigator.clipboard
          .writeText(value)
          .then(
            () => {
              alert("Copied to the clipboard!");
            },
            () => {
              alert("Failed to copy to clipboard!");
            }
          )
          .finally(() => {
            // Enable the button
            element.removeAttribute("disabled");
          });
      });
    });
  },
};
