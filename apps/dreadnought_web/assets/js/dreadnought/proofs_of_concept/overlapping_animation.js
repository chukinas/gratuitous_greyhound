// --------------------------------------------------------
// DATA

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

export default { Multip
