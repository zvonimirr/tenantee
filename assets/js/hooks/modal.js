export const ModalHook = {
  mounted() {
    this.handleEvent("phx:enable", ({ id }) => {
      const el = document.getElementById(id);

      if (el) {
        el.removeAttribute("disalbed");
      }
    });
  },
};
