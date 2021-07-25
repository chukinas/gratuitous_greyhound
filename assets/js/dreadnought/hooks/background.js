function resizeBg(backgroundEl) {
  const mainContentEl = document.querySelectorAll(".js-background-size-match")[0]
  backgroundEl.style.height = mainContentEl.offsetHeight + "px"
}

const BackgroundSizeMatch = {
  mounted() {
    const resize = () => resizeBg(this.el)
    resize()
    window.onresize = resize
  },
  updated() {
    resizeBg(this.el)
  },
}

export default {
  BackgroundSizeMatch, 
}
