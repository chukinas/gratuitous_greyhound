// --------------------------------------------------------
// CONSTANTS

const DISTANCE = 1000; // pixels
const DURATION = 10; // seconds
const SPEED = DISTANCE / DURATION; // px/sec

const getElapsedSeconds = (function() {
  const startTime = Date.now();
  return () => {
    const currentTime = Date.now();
    const elapsedMilliseconds = currentTime - startTime;
    return (elapsedMilliseconds / 1000);
  }
})();

// --------------------------------------------------------
// FUNCTIONS

function getSliderPosition() {
  const slider = document.getElementById("slider");
  return slider.getBoundingClientRect().left;
}

function calcCurrentTripDuration(elapsedSecondsTotal) {
  return elapsedSecondsTotal % DURATION;
}

function calcIdealPosition(elapsedSecondsCurrentTrip) {
  return SPEED * elapsedSecondsCurrentTrip;
}

// --------------------------------------------------------
// HOOKS

const PositionCheck = {
  mounted() {
    this.el.addEventListener("click", () => {
      const actualPosition = getSliderPosition();
      const elapsedSecondsTotal = getElapsedSeconds();
      const elapsedSecondsCurrentTrip = calcCurrentTripDuration(elapsedSecondsTotal);
      const idealPosition = calcIdealPosition(elapsedSecondsCurrentTrip);
      const positionDelta = actualPosition - idealPosition;
      const vals = {elapsedSecondsTotal, elapsedSecondsCurrentTrip, idealPosition, actualPosition, positionDelta}
      console.table(vals)
      this.pushEvent("check_time", {rand: actualPosition})
    })
  }
}

const SliderSync = {
  mounted() {
    console.log('SliderSync just mounted!');
  }
}

export default { PositionCheck, SliderSync }
