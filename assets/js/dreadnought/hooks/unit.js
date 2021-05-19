import { subscribeNewTurn } from "./turnNumber.js";

// --------------------------------------------------------
// CONSTANTS

const gsap = window.gsap
const ANIMATIONDURATION = 2 // second

// --------------------------------------------------------
// MANEUVER

function maneuver_unit(maneuveringEl) {
  const path = document.getElementById(`${maneuveringEl.id}-lastPath`)
  partialManeuver(maneuveringEl, path)
}

// TODO rename scheduleManeuver
function partialManeuver(maneuveringEl, pathEl, opts = {}) {
  opts = {
    fractionalStartTime: 0,
    fractionalDuration: 1,
    fadeout: false,
    ...opts
  }
  gsap.to(maneuveringEl, {
    motionPath: {
      autoRotate: true,
      alignOrigin: [0.5, 0.5],
      align: pathEl,
      path: pathEl,
    },
    opacity: opts.fadeout ? 0 : 1,
    ease: "none",
    delay: opts.fractionalStartTime * ANIMATIONDURATION,
    duration: opts.fractionalDuration * ANIMATIONDURATION,
  })
}

function scheduleRotation(rotatingEl, endAngle, angleTravel, opts = {}) {
  opts = {
    start: 0.5,
    duration: 0.5,
    ...opts
  }
  gsap.fromTo(rotatingEl, {
    rotation: opts.startAngle
  }, {
    rotation: `${endAngle}_${opts.direction}`,
    // rotation: '180_cw',
    ease: "none",
    delay: opts.start * ANIMATIONDURATION,
    duration: opts.duration * ANIMATIONDURATION,
  })
}

function parse_dom_string(string) {
  switch(string) {
    case "true":
      return true;
    case "false":
      return false;
  }
}

// --------------------------------------------------------
// HOOKS

const Unit = {
  mounted() {
    subscribeNewTurn(() => maneuver_unit(this.el))
  },
}

const RotationPartial = {
  mounted() {
    const data = this.el.dataset
    const rotatingElId = `unit-${data.unitId}-mount-${data.mountId}`
    const rotatingEl = document.getElementById(rotatingElId)
    console.log({data, rotatingEl, rotatingElId})
    scheduleRotation(rotatingEl, data.angle, data.travel, data)
  }
}

const PathPartial = {
  mounted() {
    const maneuveringEl = document.getElementById(this.el.dataset.maneuveringElId)
    const pathEl = this.el
    const opts = {
      fractionalStartTime: this.el.dataset.start,
      fractionalDuration: this.el.dataset.duration,
      fadeout: parse_dom_string(this.el.dataset.fadeout)
    }
    partialManeuver(maneuveringEl, pathEl, opts)
  },
}

const Animation = {
  mounted() {
    const animation = this.el
    const frames = [...animation.querySelectorAll(".dreadnought-relative-sprite")]
    const timeline = gsap.timeline({
      delay: animation.dataset.delay * ANIMATIONDURATION,
      repeat: animation.dataset.repeat,
      repeatDelay: 1
    })
    const lastFrameIndex = frames.length - 1
    console.log(lastFrameIndex)
    frames.forEach((frame, index) => {
      timeline.set(frame, {
        visibility: 'visible',
        duration: frame.dataset.duration
      })
      if (lastFrameIndex == index) {
        timeline.to(frame, {
          opacity: 0,
          duration: animation.dataset.fade
        }, `+=${frame.dataset.duration}`)
      } else {
        timeline.set(frame, {
          visibility: 'hidden',
          delay: frame.dataset.duration
        }, `+=${frame.dataset.duration}`)
      }
    })
  }
}

export default {
  Unit, 
  PathPartial, 
  RotationPartial,
  Animation,
}
