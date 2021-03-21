import * as worldTimeline from "../core/timelines.js";

// --------------------------------------------------------
// CONSTANTS

const gsap = window.gsap

// --------------------------------------------------------
// FUNCTIONS

function onUnitOutOfBounds(unitHookObject) {
  // TODO this getunittarget... doesn't feel like it's in the right module
  const unitNumber = unitHookObject.el.dataset.unitNumber
  gsap.to(worldTimeline.getUnitTarget(unitNumber), {
    opacity: 0,
    onComplete: () => {
      gameOver(unitHookObject)
    },
  })
}

function gameOver(unitHookObject) {
  unitHookObject.pushEvent("route_to", {route: "/dreadnought/gameover"})
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
  const speed = 700
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
    const unitHookObject = this;
    const unitNumber = this.el.dataset.unitNumber
    const tl = worldTimeline.getUnitTimeline(unitNumber)
    tl.eventCallback("onComplete", () => {
      onUnitOutOfBounds(unitHookObject)
    })
  },
  beforeUpdate() {
    console.log("unit element before update!")
  },
  update() {
    console.log("unit element updated!")
  },
  destroyed() {
    console.log("unit element destroyed!")
  },
}

export default { WelcomeCardShip, WelcomeCardShipFwdTurret, WelcomeCardShipRearTurret, Unit }
