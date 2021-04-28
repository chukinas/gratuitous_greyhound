import { subscribeNewTurn } from "./turnNumber.js";

// --------------------------------------------------------
// CONSTANTS

const gsap = window.gsap
const ANIMATIONDURATION = 2 // second

// --------------------------------------------------------
// MANEUVER

const has_already_maneuvered = (function() {
  const lastTurnNumbers = new Map()
  return function(el) {
    const unitId = el.id
    const turnNumber = document.getElementById("turn-number").dataset.turnNumber
    const lastTurnNumberExecuted = lastTurnNumbers.get(unitId)
    if (turnNumber == lastTurnNumberExecuted) {
      console.log("already mvr'ed")
      return true
    }
    lastTurnNumbers.set(unitId, turnNumber)
    console.log("not already mvr'ed")
    return false
  }
})()

function maneuver_unit(maneuveringEl) {
  const path = document.getElementById(`${maneuveringEl.id}-lastPath`)
  partialManeuver(maneuveringEl, 0, 1, path)
}

function partialManeuver(maneuveringEl, fractionalStartTime, fractionalDuration, pathEl) {
  gsap.to(maneuveringEl, {
    motionPath: {
      autoRotate: true,
      alignOrigin: [0.5, 0.5],
      align: pathEl,
      path: pathEl,
    },
    ease: "none",
    delay: fractionalStartTime * ANIMATIONDURATION,
    duration: fractionalDuration * ANIMATIONDURATION,
  })
}

// --------------------------------------------------------
// WELCOME SHIP PATHS

const pathIds =[
  "#welcomePathTopLeft",
  "#welcomePathTopRight",
  "#path856",
  "#path858",
  "#path860",
  "#path862",
  "#path864",
  "#path866",
  "#path868",
  "#path870",
]

function getRandItemFromArray(items) {
  return items[Math.floor(Math.random() * items.length)]
}

function getDurationFromPath(path) {
  const speed = 200
  const len = MotionPathPlugin.getLength(path)
  return len / speed
}

function randomizeStartEnd() {
  const start = getRandItemFromArray([0, 1])
  const end = Math.abs(start - 1)
  return {start, end}
}

function animateShip(shipElement) {
  const path = getRandItemFromArray(pathIds)
  gsap.to(shipElement, {
    motionPath: {
      autoRotate: true,
      alignOrigin: [0.5, 0.5],
      align: path,
      path,
      ...randomizeStartEnd()
    },
    ease: 'none',
    duration: getDurationFromPath(path),
    onComplete: () => animateShip(shipElement)
  })
}

// --------------------------------------------------------
// HOOKS

const WelcomeCardShip = {
  mounted() {
    animateShip(this.el)
  }
}

const WelcomeCardShipFwdTurret = {
  mounted() {
    gsap.to(this.el, {duration: 3, rotation: -60, ease: Sine.easeInOut})
  }
}

const WelcomeCardShipRearTurret = {
  mounted() {
    gsap.set(this.el, {rotation: 180, ease: Sine.easeInOut})
    gsap.to(this.el, {duration: 3, rotation: "+=120", ease: Sine.easeInOut})
  }
}

const Unit = {
  mounted() {
    subscribeNewTurn(() => maneuver_unit(this.el))
  },
  //beforeUpdate() {
  //  console.log("unit before update")
  //},
  //updated() {
  //  console.log("unit updated")
  //  if (!has_already_maneuvered(this.el)) {
  //    maneuver_unit(this.el)
  //  }
  //},
}

const PartialPath = {
  mounted() {
    const maneuveringEl = document.getElementById(this.el.dataset.maneuveringElId)
    const pathEl = this.el
    const fractionalStartTime = this.el.dataset.start
    const fractionalDuration = this.el.dataset.duration
    console.log(this.el.dataset)
    partialManeuver(maneuveringEl, fractionalStartTime, fractionalDuration, pathEl)
  },
}

export default { WelcomeCardShip, WelcomeCardShipFwdTurret, WelcomeCardShipRearTurret, Unit, PartialPath }
