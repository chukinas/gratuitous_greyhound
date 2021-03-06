// TODO export the timeline as a named export
import * as worldTimeline from "../core/timelines.js";
import { Commands } from "../core/commands.js"

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
    const stepId = parseInt(this.el.dataset.stepId)
    this.el.addEventListener("click", () => {
      Commands.selectStep(stepId)
    })
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
