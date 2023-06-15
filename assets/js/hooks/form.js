export const FormHook = {
  mounted() {
    const required = this.el.dataset.required.split(",");
    const button = this.el.querySelector("button[type=submit]");

    // If any of the required fields are empty, disable the submit button
    // else enable it.
    const checkRequired = () => {
      const empty = required.some((field) => {
        const input = this.el.querySelector(`[name=${field}]`);
        return !input.value;
      });

      if (empty) {
        button.setAttribute("disabled", true);
      } else {
        button.removeAttribute("disabled");
      }
    };

    // Check required fields on page load
    checkRequired();

    // Check required fields on input change
    for (const field of required) {
      const input = this.el.querySelector(`[name=${field}]`);
      input.addEventListener("input", checkRequired);
    }
  },
};
