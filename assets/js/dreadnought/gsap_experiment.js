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

const CheckGsapLoad = {
  mounted() {
    checkGsapLoad();
    this.el.addEventListener("click", () => {
      checkGsapLoad();
    })
  }
}

export default { CheckGsapLoad }
