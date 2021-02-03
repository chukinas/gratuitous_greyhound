// --------------------------------------------------------
// CONSTANTS

// --------------------------------------------------------
// FUNCTIONS

function checkGsapLoad() {
  const gsap = window.gsap;
  console.log(gsap);
}

// --------------------------------------------------------
// HOOKS

export const CheckGsapLoad = {
  mounted() {
    checkGsapLoad();
    this.el.addEventListener("click", () => {
      checkGsapLoad();
    })
  }
}

export const MoveSlider = {
  mounted() {
    window.gsap.to(this.el, {ease: 'none', duration: 10, x: 1000, repeat: -1})
  }
}
