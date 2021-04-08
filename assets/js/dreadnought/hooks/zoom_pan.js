import { PointerEvents } from '../core/pointers.js'
import { Coord } from '../core/coordinates.js'

// --------------------------------------------------------
// CONFIG

const interval = 100 // pan debounce interval (ms)
const DURATION = 0.2 // tween duration (ms)
const scaleStep = 0.2
const maxZoomInScale = 0.4
const panMultiplier = 1.5

// --------------------------------------------------------
// DATA

// Global vars to cache event state
const gsap = window.gsap
// On PointerDown, save the current elZoomPanCover and pointer coords here:
const initial = {
  coord: null,
  zoom: null
}

// --------------------------------------------------------
// DOM REFERENCES

// elZoomPanContainer must be a fixed element sized to the viewport.
let elZoomPanContainer
// elZoomPanCover is a child element of elZoomPanContainer.
// This element will always cover the viewport.
// In other words, it will never be allows to pan 
// so far that the background is visible behind it.
// Note: currently, the user is actually able to pan beyond this point, 
// but it snaps back to full cover when the pointer lifts off.
let elZoomPanCover
// elZoomPanFit is also a child of elZoomPanContainer (and optionally
// also of elZoomPanCover). It is smaller than elZoomPanCover and fits within it.
// This element's bounding rect is where most of the app's action occurs. 
// For Dreadnought, this element is almost synonymous with the arena.
let elZoomPanFit

function getWorldRect() { return elZoomPanCover.getBoundingClientRect() }
function getArenaRect() { return elZoomPanFit.getBoundingClientRect() }


function coordFromTransformedElement(element) {
  const coordAndScale = getCoordAndScale(element)
  return { x: coordAndScale.x, y: coordAndScale.y }
}

function getCoordAndScale(element) {
  // FROM: https://zellwk.com/blog/css-translate-values-in-javascript/
  const style = window.getComputedStyle(element)
  const matrix = style['transform'] || style.webkitTransform || style.mozTransform
  // No transform property. Simply return 0 values.
  if (matrix === 'none' || typeof matrix === 'undefined') {
    return Coord.origin()
  }
  // Can either be 2d or 3d transform
  const matrixType = matrix.includes('3d') ? '3d' : '2d'
  const matrixValues = matrix.match(/matrix.*\((.+)\)/)[1].split(', ')
  // 2d matrices have 6 values
  // Last 2 values are X and Y.
  // 2d matrices does not have Z value.
  if (matrixType === '2d') {
    return {
      x: Number(matrixValues[4]),
      y: Number(matrixValues[5]),
      scale: Number(matrixValues[0]),
    }
  }
  // 3d matrices have 16 values
  // The 13th, 14th, and 15th values are X, Y, and Z
  if (matrixType === '3d') {
    return {
      x: Number(matrixValues[12]),
      y: Number(matrixValues[13]),
      scale: Number(matrixValues[0]),
    }
  }
}

// --------------------------------------------------------
// FUNCTIONS

// function getCurrentScale() {
//   return getCoordAndScale(elZoomPanCover).scale
// }
// 
// function zoomIn() {
//   const currentScale = getCurrentScale()
//   const scale = Math.max(maxZoomInScale, currentScale + scaleStep)
//   gsap.to(elZoomPanCover, {
//     scale: "+=" + scaleStep,
//     DURATION,
//     ease: 'back',
//     onComplete: coverWorldContainer
//   })
// }
// 
// function zoomOut() {
//   const currentScale = getCurrentScale()
//   const maxZoomOutScale = getScaleToCover(elZoomPanCover)
//   const isAlreadyAtMaxZoomOut = currentScale < maxZoomOutScale + 0.001
//   if (isAlreadyAtMaxZoomOut) {
//     gsap.fromTo(elZoomPanCover, {
//       scale: maxZoomOutScale * 0.95
//     },{
//       DURATION,
//       scale: maxZoomOutScale,
//       ease: 'back',
//       onComplete: coverWorldContainer
//     })
//   }
//   else {
//     const scale = Math.max(maxZoomOutScale, currentScale - scaleStep)
//     gsap.to(elZoomPanCover, {
//       scale,
//       DURATION,
//       ease: 'back',
//       onComplete: coverWorldContainer
//     })
//   }
// }
// 
// function getScales() {
//   // Basically, how much bigger is the elZoomPanFit/elZoomPanCover than the window?
//   const windowSize = {x: window.innerWidth, y: window.innerHeight}
//   const arenaRect = getArenaRect()
//   const arenaSize = { x: arenaRect.width, y: arenaRect.height}
//   return {
//     x: windowSize.x / arenaSize.x,
//     y: windowSize.y / arenaSize.y
//   }
// }
// 
// const getScalesAsArray = () => Object.values(getScales())
// // Min Scale is needed to set a Zoom Out limit
// const getMinScale = () => Math.min(...getScalesAsArray())
// // Max Scale is needed to set a Zoom In limit
// const getMaxScale = () => Math.max(...getScalesAsArray())
// 
// function getFitScale(element) {
//   const elementRect = element.getBoundingClientRect()
//   const worldContainerRect = elZoomPanContainer.getBoundingClientRect()
//   const relWidthScale = worldContainerRect.width / elementRect.width
//   const relHeightScale = worldContainerRect.height / elementRect.height
//   const relScale = Math.min(relWidthScale, relHeightScale)
//   const absScale = relScale * getCurrentScale()
//   return absScale
// }
// 
// function getElementOrigSize(element) {
//   // TODO temp
//   return Coord.origin()
// }
// 
// // TODO rename
// function getScaleToCover(element) {
//   // DRYify
//   const elementRect = element.getBoundingClientRect()
//   const worldContainerRect = elZoomPanContainer.getBoundingClientRect()
//   const relWidthScale = worldContainerRect.width / elementRect.width
//   const relHeightScale = worldContainerRect.height / elementRect.height
//   const relScale = Math.max(relWidthScale, relHeightScale)
//   const absScale = relScale * getCurrentScale()
//   return absScale
// }
// 
// function getRelPosition(elFrom, elTo) {
//   return MotionPathPlugin.getRelativePosition(elFrom, elTo, [0.5, 0.5], [0.5, 0.5])
// }
// 
// function fitArena(opts = {zeroDuration: false}) {
//   const relCoord = getRelPosition(elZoomPanContainer, elZoomPanFit)
//   const scale = Math.max(getFitScale(elZoomPanFit), getScaleToCover(elZoomPanCover))
//   const isAlreadyAtFitScale = Math.abs(scale - getCurrentScale()) < 0.001
//   const isAlreadyCentered = Coord.isApproxZero(relCoord)
//   if (opts.zeroDuration) {
//     gsap.set(elZoomPanCover, {
//       scale,
//       x: "-=" + relCoord.x,
//       y: "-=" + relCoord.y,
//     })
// 
//   } else if (isAlreadyAtFitScale & isAlreadyCentered) {
//     gsap.from(elZoomPanCover, {
//       scale: scale * 0.95,
//       DURATION
//     })
//   } else {
//     gsap.to(elZoomPanCover, {
//       scale,
//       x: "-=" + relCoord.x,
//       y: "-=" + relCoord.y,
//       DURATION,
//       ease: "back"
//     })
//   }
// }

function pan(initialCoord, currentCoord) {
  console.log(initialCoord, currentCoord)
  let panVector = Coord.subtract(currentCoord, initialCoord)
  panVector = Coord.multiply(panVector, panMultiplier)
  const nextWorldCoord = Coord.add(initial.position, panVector)
  console.log({initialCoord, currentCoord, nextWorldCoord, elZoomPanCover})
  gsap.to(elZoomPanCover, {
    ...nextWorldCoord,
  })
}

function coverWorldContainer() {
  const worldContainerRect = elZoomPanContainer.getBoundingClientRect()
  const worldRect = getWorldRect()
  const tooFarRight = Math.min(0, -worldRect.left)
  const tooFarTop = Math.min(0, -worldRect.top)
  const tooFarLeft = Math.max(0, worldContainerRect.right - worldRect.right)
  const tooFarBottom = Math.max(0, worldContainerRect.bottom - worldRect.bottom)
  const panVector = {
    x: tooFarRight || tooFarLeft || 0,
    y: tooFarTop || tooFarBottom || 0,
  }
  if (panVector.x || panVector.y) {
    const currentWorldCoord = coordFromTransformedElement(elZoomPanCover)
    gsap.to(elZoomPanCover, {
      ...Coord.add(currentWorldCoord, panVector),
      ease: 'back',
      DURATION
    })
  }
}

// Log events flag
let logToElixir = () => {}
function log(description, ev) {
  logToElixir({
    description,
    pointerId: ev.pointerId,
    pointerType: ev.pointerType,
    isPrimary: ev.isPrimary,
    coord: [ev.clientX, ev.clientY]
  })
} 

function onPointerDown(ev) {
  if (PointerEvents.down(ev)) {
    initial.position = coordFromTransformedElement(elZoomPanCover)
  }
  console.log(initial)
}

// --------------------------------------------------------
// HOOKS

const ZoomPanContainer = {
  mounted() {
    PointerEvents.setPanCallback(pan)
    const me = this
    // Set DOM reference
    elZoomPanContainer = this.el
    // Set pointer event handlers
    elZoomPanContainer.onpointerdown = onPointerDown;
    elZoomPanContainer.onpointermove = PointerEvents.move
    elZoomPanContainer.onpointerup = PointerEvents.up;
    elZoomPanContainer.onpointercancel = PointerEvents.up;
    elZoomPanContainer.onpointerout = PointerEvents.up;
    elZoomPanContainer.onpointerleave = PointerEvents.up;
    logToElixir = (params) => {
      me.pushEvent("log", params)
    }
    logToElixir({test: "TEST"})
    // TODO rename
    //setTimeout(() => fitArena({zeroDuration: true})) 
  },
  // updated() {
  //   setTimeout(() => fitArena({zeroDuration: true})) 
  //   //fitArena({zeroDuration: true})
  // },
  // destroyed() {
  //   elZoomPanContainer = null;
  //   elZoomPanCover = null;
  //   elZoomPanFit = null;
  // }
}

const ZoomPanCover = {
  mounted() {
    elZoomPanCover = this.el
  }
}

const ZoomPanFit = {
  mounted() {
    elZoomPanFit = this.el
  }
}

// TODO rename ButtonFit
const ButtonFitArena = {
  mounted() {
    // TODO rename fit
    // this.el.onclick = fitArena
  }
}

const ButtonZoomIn = {
  mounted() {
    this.el.onclick = zoomIn
  }
}

const ButtonZoomOut = {
  mounted() {
    this.el.onclick = zoomOut
  }
}
// TODO rename file zoomPan.js
export default { ZoomPanContainer, ZoomPanCover, ZoomPanFit, ButtonFitArena, ButtonZoomIn, ButtonZoomOut }
