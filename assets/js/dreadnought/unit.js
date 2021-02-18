// --------------------------------------------------------
// CONSTANTS

// --------------------------------------------------------
// FUNCTIONS

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
    gsap.to(this.el, {
      motionPath: {
        autoRotate: true,
        path: "#unit--2--segment--1",
        align: "#unit--2--segment--1",
      },
      repeat: -1,
      duration: 4
    })
  }
}

export default { WelcomeCardShip, WelcomeCardShipFwdTurret, WelcomeCardShipRearTurret, Unit }
