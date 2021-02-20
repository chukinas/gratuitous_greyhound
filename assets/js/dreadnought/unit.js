import * as worldTimeline from "./worldTimeline.js";

// --------------------------------------------------------
// CONSTANTS

const gsap = window.gsap

// --------------------------------------------------------
// FUNCTIONS

function onUnitOutOfBounds(unitHookObject) {
  console.log("unit out of bounds")
  // TODO this getunittarget... doesn't feel like it's in the right module
  const unitNumber = unitHookObject.el.dataset.unitNumber
  gsap.to(worldTimeline.getUnitTarget(unitNumber), {
    opacity: 0,
    onComplete: () => {
      console.log("on complete")
      gameOver(unitHookObject)
    },
  })
}

function gameOver(unitHookObject) {
  console.log("game over")
  unitHookObject.pushEvent("game_over")
}

// --------------------------------------------------------
// HOOKS

const WelcomeCardShip = {
  mounted() {
    gsap.set(this.el, {x: -100, y: 700})
    gsap.to(this.el, {
      motionPath: {
        autoRotate: true,
          path: [
            {x: 800, y: 200},
            {x: 900, y: -200},
          ]
      },
      repeat: -1,
      duration: 20})
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
  }
}

export default { WelcomeCardShip, WelcomeCardShipFwdTurret, WelcomeCardShipRearTurret, Unit }
