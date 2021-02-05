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

const sliderTimeline = window.gsap.timeline();

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

function getActualPositionAndPrintState() {
  const actualPosition = getSliderPosition();
  const elapsedSecondsTotal = getElapsedSeconds();
  const elapsedSecondsCurrentTrip = calcCurrentTripDuration(elapsedSecondsTotal);
  const idealPosition = calcIdealPosition(elapsedSecondsCurrentTrip);
  const positionDelta = actualPosition - idealPosition;
  const vals = {elapsedSecondsTotal, elapsedSecondsCurrentTrip, idealPosition, actualPosition, positionDelta}
  console.table(vals)
  return actualPosition;
}

// --------------------------------------------------------
// HOOKS

const PositionCheck = {
  mounted() {
    this.el.addEventListener("click", () => {
      const actualPosition = getActualPositionAndPrintState();
      this.pushEvent("check_time", {rand: actualPosition})
    })
  }
}

const Slider = {
  mounted() {
    sliderTimeline.to(this.el, {ease: 'none', duration: 10, x: 1000, repeat: -1})
  }
}
 
const SliderSync = {
  mounted() {
    this.el.addEventListener("click", () => {
      console.log("Slider state prior to sync:");
      getActualPositionAndPrintState();
      sliderTimeline.seek(getElapsedSeconds());
      console.log("Slider state after sync:");
      getActualPositionAndPrintState();
    })
  }
}

export default { PositionCheck, Slider, SliderSync }
