import * as worldTimeline from "./worldTimeline.js";

// --------------------------------------------------------
// CONSTANTS

// --------------------------------------------------------
// FUNCTIONS

function getUnitTarget(segment) {
  return "#unit--" + segment.dataset.unitId
}

// --------------------------------------------------------
// HOOKS

const Segment = {
  mounted() {
    worldTimeline.addTween(getUnitTarget(this.el), {
      motionPath: {
        autoRotate: true,
        path: this.el,
        align: this.el,
        alignOrigin: [0.5, 0.5],
      },
    }, this.el.dataset.segmentNumber)
  }
}

const ToggleWorldPlay = {
  mounted() {
    this.el.addEventListener("click", worldTimeline.toggle)
  }
}

export default { Segment, ToggleWorldPlay }
