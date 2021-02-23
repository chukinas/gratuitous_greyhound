// --------------------------------------------------------
// CONSTANTS

// --------------------------------------------------------
// FUNCTIONS

function checkGsapLoad() {
  const gsap = window.gsap;
  // console.log(gsap);
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
