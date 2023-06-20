export const FormHook = {
  mounted() {
    const button = this.el.querySelector("button[type=submit]");

    const inputs = this.el.querySelectorAll("input");
    const selects = this.el.querySelectorAll("select");
    const textareas = this.el.querySelectorAll("textarea");

    const elements = [...inputs, ...selects, ...textareas];

    const validate = () => {
      // Check if all inputs are valid
      const allValid = elements.every((element) => element.checkValidity());

      // If all inputs are valid, enable the submit button
      if (allValid) {
        button.removeAttribute("disabled");
        return;
      }

      // If not all inputs are valid, disable the submit button
      if (!allValid) {
        button.setAttribute("disabled", "disabled");
      }
    };

    // Validate on load
    validate();

    // Validate on input change

    elements.forEach((element) => {
      element.addEventListener("input", validate);
    });
  },
};
