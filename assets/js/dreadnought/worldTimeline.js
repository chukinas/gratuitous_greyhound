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
const stateChangeCallbacks = [() => console.log(currentState)]
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
      executeStateChangeCallbacks();
      break;
    case "playing":
      currentState = "paused"
      worldTimeline.pause()
      executeStateChangeCallbacks();
      break;
    case "paused":
      currentState = "playing"
      worldTimeline.play()
      executeStateChangeCallbacks()
      break;
  }
}

export function subscribeStateChanges(callback) {
  stateChangeCallbacks.push(callback)
}

// --------------------------------------------------------
// PRIVATE FUNCTIONS

function complete() {
  if (currentState != "complete") {
    currentState = "complete"
    executeStateChangeCallbacks()
  }
}

function getStartTime(segment) {
  // TODO create stylesheet. Incl eg data attr are dash-separated, which converts to camelCase in js. IDs follow eg something--XY--else--AB
  return (segment - 1) * segmentDuration;
}

function executeStateChangeCallbacks() {
  stateChangeCallbacks.forEach(callback => callback(currentState))
}
