import * as worldTimeline from "../core/worldTimeline.js";

// --------------------------------------------------------
// DATA

// --------------------------------------------------------
// FUNCTIONS

// --------------------------------------------------------
// HOOKS

const DisplaySegment = {
  mounted() {
    worldTimeline.animateSegment(
      this.el.dataset.unitNumber,
      this.el.dataset.segmentNumber,
      this.el
    )
  }
}

const SegmentClickTarget = {
  mounted() {
    console.log("Mounting SegmentClickTarget!", this.el.dataset.stepId)
  }
}

const BeginButton = {
  mounted() {
    this.el.addEventListener("click", () => {
      worldTimeline.play()
      this.el.hidden = true
    })
  }
}

export default { DisplaySegment, BeginButton, SegmentClickTarget }
