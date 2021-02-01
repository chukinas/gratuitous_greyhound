let DreadnoughtHooks = {}

DreadnoughtHooks.PositionCheck = {
  mounted() {
    this.el.addEventListener("click", () => { console.log("hi!!!!")})
  }
}

export {DreadnoughtHooks}
