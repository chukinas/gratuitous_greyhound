let DreadnoughtHooks = {}

DreadnoughtHooks.PositionCheck = {
  mounted() {
    this.el.addEventListener("click", () => {
      const slider = document.getElementById("slider");
      const xPosition = slider.getBoundingClientRect().left
      this.pushEvent("check_time", {rand: Math.round(xPosition)})
    })
  }
}

export {DreadnoughtHooks}
