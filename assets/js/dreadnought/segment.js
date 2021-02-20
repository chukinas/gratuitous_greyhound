// --------------------------------------------------------
// CONSTANTS

const segmentDuration = 2.5; // seconds
const worldTimeline = gsap.timeline({defaults: {
  ease: "none", 
  duration: segmentDuration,
}})

// --------------------------------------------------------
// FUNCTIONS

function getStartTime(segment) {
  // TODO create stylesheet. Incl eg data attr are dash-separated, which converts to camelCase in js. IDs follow eg something--XY--else--AB
  return (segment.dataset.segmentNumber - 1) * segmentDuration;
}

function getUnitTarget(segment) {
  return "#unit--" + segment.dataset.unitId
}

// --------------------------------------------------------
// HOOKS

const Segment = {
  mounted() {
    const tl = worldTimeline.to(getUnitTarget(this.el), {
      motionPath: {
        autoRotate: true,
        path: this.el,
        align: this.el,
        alignOrigin: [0.5, 0.5],
      },
    }, getStartTime(this.el))
    console.log(tl)
  }
}

export default { Segment }
