// --------------------------------------------------------
// CONSTANTS

const gsap = window.gsap
const ANIMATIONDURATION = 2 // second

// --------------------------------------------------------
// HELPERS

function parse_dom_string(string) {
  switch(string) {
    case "true":
      return true;
    case "false":
      return false;
  }
}

function unitElId(unitId) {
  return `unit-${unitId}`
}

function unitEl(unitId) {
  return document.getElementById(unitElId(unitId))
}

// TODO rename delayAndDurationFromElData
function delayAndDuration(data) {
  console.log(data, "my svg dot's data attrs")
  if (data) {
    return {
      delay: data.delay * ANIMATIONDURATION,
      duration: data.duration * ANIMATIONDURATION
    }
  } else {
    return {
      delay: 0,
      duration: 5,
    }
  }
}

function mount_recoil(mountEl) {
  const el = mountEl.getElementsByClassName('js-mount-recoil')[0]
  gsap.from(el, { x: -5 })
}

// --------------------------------------------------------
// UNIT EVENTS

function maneuver(eventEl, unitId) {
  const targetEl = unitEl(unitId)
  const data = eventEl.dataset
  const pathElId = `${unitElId(unitId)}-path-${data.id}`
  const pathEl = document.getElementById(pathElId)
  if (!targetEl || !pathEl) {
    console.error("Either the target or the path could not be found:")
    console.log(targetEl, pathEl)
    return
  }
    console.log(targetEl, pathEl)
  gsap.to(targetEl, {
    motionPath: {
      autoRotate: true,
      alignOrigin: [0, 0],
      //alignOrigin: [0.5, 0.5],
      align: pathEl,
      path: pathEl,
    },
    ease: "none",
    ...delayAndDuration(data)
  })
}

function fade(eventEl, unitId) {
  const data = eventEl.dataset
  gsap.fromTo(unitEl(unitId), {
    opacity: 1
  }, {
    opacity: 0,
    ease: "none",
    ...delayAndDuration(data)
  })
}

function rotateMount(eventEl, unitId) {
  const data = eventEl.dataset
  const rotatingElId = `unit-${unitId}-mount-${data.mountId}`
  const mountEl = document.getElementById(rotatingElId)
  gsap.fromTo(mountEl, {
    rotation: data.startAngle
  }, {
    rotation: `${data.endAngle}_${data.direction}`,
    ease: "none",
    delay: data.delay * ANIMATIONDURATION,
    duration: data.duration * ANIMATIONDURATION,
    // TODO This approack assumes that a mount is always only ever rotated in order to fire it.
    // But there will probably come a day when I want to rotate a turret without firing it
    onComplete: () => mount_recoil(mountEl)
  })
}

const events = {
  maneuver: maneuver,
  fadeout: fade,
  mountRotation: rotateMount
}

// --------------------------------------------------------
// HOOKS

// TEMP while troubleshooting my new SVGs

const MotionPathExperiment = {
  mounted() {
    const targetEl = this.el
    const pathElId = "unit-1-path-1"
    const pathEl = document.getElementById(pathElId)
    if (!targetEl || !pathEl) {
      console.error("Either the target or the path could not be found:")
      console.log(targetEl, pathEl)
      return
    }
    console.log(targetEl, pathEl)
    gsap.to(targetEl, {
      motionPath: {
        autoRotate: true,
        //alignOrigin: ["50px", "50px"],
        //alignOrigin: [0, 0],
        alignOrigin: [0.5, 0.5],
        align: pathEl,
        path: pathEl,
      },
      ease: "none",
      ...delayAndDuration()
    })
  },
}

const UnitEvents = {
  mounted() {
    const unitId = this.el.dataset.unitId
    const eventsList = this.el.children
    for (const eventEl of eventsList) {
      const eventType = eventEl.dataset.eventType
      const fun = events[eventType]
      if (!fun) throw(`This unit event has no handler yet: ${eventType}`)
      fun(eventEl, unitId)
    }
  },
}

const Animation = {
  mounted() {
    const animation = this.el
    const frames = [...animation.querySelectorAll(".js-animation-frame-sprite")]
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
  UnitEvents, 
  Animation,
  MotionPathExperiment
}
