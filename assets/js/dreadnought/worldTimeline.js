// TODO hooks modules should maybe be in their own hooks dir?
// --------------------------------------------------------
// DATA

const segmentDuration = 1; // seconds
const worldTimeline = window.gsap.timeline({
  paused: true,
  onComplete: complete,
  autoRemoveChildren: true,
  defaults: {
    ease: "none", 
    duration: segmentDuration,
  },
})
let currentState = "notStarted"

// --------------------------------------------------------
// PUBLIC FUNCTIONS

export function addTween(target, vars, segment) {
  worldTimeline.to(target, vars, getStartTime(segment))
}

export function toggle() {
  switch(currentState) {
    case "notStarted":
      currentState = "playing"
      worldTimeline.play()
      break;
    case "playing":
      currentState = "paused"
      worldTimeline.pause()
      break;
    case "paused":
      currentState = "playing"
      worldTimeline.play()
      break;
  }
  console.log(currentState)
}

// --------------------------------------------------------
// PRIVATE FUNCTIONS

function complete() {
  if (currentState != "complete") {
    currentState = "complete"
    console.log(currentState)
  }
}

function getStartTime(segment) {
  // TODO create stylesheet. Incl eg data attr are dash-separated, which converts to camelCase in js. IDs follow eg something--XY--else--AB
  return (segment - 1) * segmentDuration;
}
