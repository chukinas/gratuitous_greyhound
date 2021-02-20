// --------------------------------------------------------
// CONSTANTS

const segmentDuration = 1; // seconds
const worldTimeline = gsap.timeline({
  onComplete: printTimeLineInfo,
  autoRemoveChildren: true,
  defaults: {
    ease: "none", 
    duration: segmentDuration,
  },
})

// --------------------------------------------------------
// FUNCTIONS

function getStartTime(segment) {
  // TODO create stylesheet. Incl eg data attr are dash-separated, which converts to camelCase in js. IDs follow eg something--XY--else--AB
  return (segment.dataset.segmentNumber - 1) * segmentDuration;
}

function getUnitTarget(segment) {
  return "#unit--" + segment.dataset.unitId
}

function printTimeLineInfo() {
  console.log(worldTimeline.getChildren())
}

// --------------------------------------------------------
// HOOKS

const Segment = {
  mounted() {
    worldTimeline.to(getUnitTarget(this.el), {
      motionPath: {
        autoRotate: true,
        path: this.el,
        align: this.el,
        alignOrigin: [0.5, 0.5],
      },
      onComplete: printTimeLineInfo,
    }, getStartTime(this.el))
  }
}

export default { Segment }
