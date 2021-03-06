// TODO rename module to `timelines`?
// --------------------------------------------------------
// DATA

const gsap = window.gsap;
const segmentDuration = 0.3; // seconds
const worldTimeline = gsap.timeline({
  paused: true,
  autoRemoveChildren: true,
  defaults: {
    ease: "none", 
    duration: segmentDuration,
  },
})
const unitTimelines = new Map();

// --------------------------------------------------------
// PUBLIC FUNCTIONS

export function play() {
  worldTimeline.play()
}

export function getUnitTimeline(unitNumber) {
  if (!unitTimelines.has(unitNumber)) {
    const newUnitTimeline = gsap.timeline({
    });
    worldTimeline.add(newUnitTimeline, 0)
    unitTimelines.set(unitNumber, newUnitTimeline)
  }
  return unitTimelines.get(unitNumber)
}


export function getUnitTarget(unitNumber) {
  return "#unit--" + unitNumber
}

export function animateSegment(unitId, stepId, segmentElement) {
  getUnitTimeline(unitId).to(getUnitTarget(unitId), {
    motionPath: {
      autoRotate: true,
      path: segmentElement,
      align: segmentElement,
      alignOrigin: [0.5, 0.5],
    },
  }, getStartTime(stepId))
}

// --------------------------------------------------------
// PRIVATE FUNCTIONS

// TODO rename segment to segmentNumber
function getStartTime(segment) {
  // TODO create stylesheet. Incl eg data attr are dash-separated, which converts to camelCase in js. IDs follow eg something--XY--else--AB
  return (segment - 1) * segmentDuration;
}
