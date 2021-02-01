function buildGetDurationFunction() {
  const startTime = Date.now();
  return () => {
    const currentTime = Date.now();
    const elapsedMilliseconds = currentTime - startTime;
    return (elapsedMilliseconds / 1000);
  }
}

function getSliderPosition() {
  const slider = document.getElementById("slider");
  const xPosition = slider.getBoundingClientRect().left
  return Math.round(xPosition)
}

let DreadnoughtHooks = {}

DreadnoughtHooks.PositionCheck = {
  mounted() {
    const getDuration = buildGetDurationFunction();
    this.el.addEventListener("click", () => {
      console.log(getDuration());
      this.pushEvent("check_time", {rand: getSliderPosition()})
    })
  }
}

export {DreadnoughtHooks}
