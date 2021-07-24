function resizeBg(backgroundEl) {
  const mainContentEl = document.querySelectorAll(".js-background-size-match")[0]
  backgroundEl.style.height = mainContentEl.offsetHeight + "px"
  // console.log(backgroundEl)
}

const BackgroundSizeMatch = {
  mounted() {
    resizeBg(this.el)
  },
  updated() {
    resizeBg(this.el)
  },
}

export default {
  BackgroundSizeMatch, 
}
