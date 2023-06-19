export const FormHook = {
  mounted() {
    const required = this.el.dataset.required.split(",");
    const min = this.el.querySelectorAll("[min]");
    const max = this.el.querySelectorAll("[max]");
    const button = this.el.querySelector("button[type=submit]");

    const minMax = [...min, ...max];

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

    // Check min and max values of the input fields, and disable the submit
    // button if the values are out of range, else enable it.
    const checkMinMax = () => {
      const outOfRange = minMax.some((input) => {
        const value = parseFloat(input.value);
        const min = parseFloat(input.getAttribute("min"));
        const max = parseFloat(input.getAttribute("max"));

        if (isNaN(value)) {
          return true;
        }

        if (!isNaN(min) && value < min) {
          return true;
        }

        if (!isNaN(max) && value > max) {
          return true;
        }
      });

      if (outOfRange) {
        button.setAttribute("disabled", true);
      } else {
        button.removeAttribute("disabled");
      }
    };

    // Check required fields on page load
    checkRequired();
    // Check min and max values on page load
    if (minMax.length > 0) {
      checkMinMax();
    }

    // Check required fields on input change
    for (const field of required) {
      const input = this.el.querySelector(`[name=${field}]`);
      input.addEventListener("input", checkRequired);
    }

    // Check min and max values on input change
    for (const input of minMax) {
      input.addEventListener("input", checkMinMax);
    }
  },
};
