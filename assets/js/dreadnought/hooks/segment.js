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

const Segment = {
  mounted() {
    worldTimeline.addTween(this.el.dataset.unitNumber, {
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
    const el = this.el
    const stateCallback = (state) => {
      configurePlayButton(el, state)
    }
    stateCallback("notStarted")
    el.addEventListener("click", worldTimeline.toggle)
    worldTimeline.subscribeStateChanges(stateCallback)
  }
}

export default { Segment, ToggleWorldPlay }
