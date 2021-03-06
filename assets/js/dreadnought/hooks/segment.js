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
    Commands.applyActiveOrInactiveStyling(this.el)
  },
  updated() {
    // TODO I don't like that I have to call this.
    // The better longterm solution is to figure out why the server
    // is updating segments when a new command is selected
    Commands.applyActiveOrInactiveStyling(this.el)
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

const IssueCommand = {
  mounted() {
    const me = this
    const issueCommandEvent = () => {
      const stepId = Commands.getStepId()
      me.pushEvent("issue_command", {step_id: stepId})
    }
    this.el.addEventListener("click", issueCommandEvent)
  }
}

export default { DisplaySegment, BeginButton, SegmentClickTarget, IssueCommand }
