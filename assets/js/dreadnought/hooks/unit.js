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

function parse_dom_string(string) {
  switch(string) {
    case "true":
      return true;
    case "false":
      return false;
  }
}

function rotateMount(eventEl, unitId) {
  const data = eventEl.dataset
  const rotatingElId = `unit-${unitId}-mount-${data.mountId}`
  const rotatingEl = document.getElementById(rotatingElId)
  gsap.fromTo(rotatingEl, {
    rotation: data.startAngle
  }, {
    rotation: `${data.endAngle}_${data.direction}`,
    ease: "none",
    delay: data.delay * ANIMATIONDURATION,
    duration: data.duration * ANIMATIONDURATION,
  })
}

const events = {
  mountRotation: rotateMount
}

// --------------------------------------------------------
// HOOKS

const Unit = {
  mounted() {
  },
  updated() {
    const unitEl = this.el
    const unitId = unitEl.dataset.unitId
    const eventsListElId = `unit-${unitId}-events`
    const eventsList = document.getElementById(eventsListElId).children
    for (const eventEl of eventsList) {
      const fun = events[eventEl.dataset.eventType]
      fun(eventEl, unitId)
    }
  },
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
  Animation,
}
