import * as worldTimeline from "../core/worldTimeline.js";

// --------------------------------------------------------
// DATA

const playBtnConfig = {
  notStarted: {
    disabled: false,
    innerText: "Start",
  },
  playing: {
    disabled: false,
    innerText: "Pause",
  },
  paused: {
    disabled: false,
    innerText: "Resume",
  },
  complete: {
    disabled: true,
    innerText: "Done!",
  },
}

// --------------------------------------------------------
// FUNCTIONS

function configurePlayButton(el, state) {
  const config = playBtnConfig[state]
  el.innerText = config.innerText
}

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

const ToggleWorldPlay = {
  mounted() {
    const el = this.el
    const stateCallback = (state) => {
      configurePlayButton(el, state)
    }
    stateCallback("notStarted")
    el.addEventListener("click", worldTimeline.toggle)
    worldTimeline.subscribeStateChanges(stateCallback)
  }
}

export default { DisplaySegment, ToggleWorldPlay }
