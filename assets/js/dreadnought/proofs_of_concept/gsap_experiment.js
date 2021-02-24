// --------------------------------------------------------
// CONSTANTS

const gsap = window.gsap;

// --------------------------------------------------------
// FUNCTIONS

function checkGsapLoad() {
  const gsap = window.gsap;
  // console.log(gsap);
}

// --------------------------------------------------------
// HOOKS

const CheckGsapLoad = {
  mounted() {
    checkGsapLoad();
    this.el.addEventListener("click", () => {
      checkGsapLoad();
    })
  }
}

const MultipleAnimations = {
  mounted() {
    gsap.to(this.el, {
      x: 1000,
      // ease: 'none',
      duration: 2
    })
    gsap.to(this.el, {
      x: 0,
      y: -500,
      duration: 2,
      // ease: 'none',
    }, 1)
  }
}

export default { MultipleAnimations }
