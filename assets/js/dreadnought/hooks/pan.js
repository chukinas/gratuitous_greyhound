// --------------------------------------------------------
// DATA

// Global vars to cache event state
const gsap = window.gsap
const interval = 100 // pan debounce interval (ms)
let panIntervalId
const panMultiplier = 1.5
// On PointerDown, save the current world and pointer coords here:
let atPanStart
// On PointerMove, save pointer coord here:
let pointerCoord

// --------------------------------------------------------
// DOM REFERENCES

let worldContainer
let world
let arena

function getWorldRect() { return world.getBoundingClientRect() }
function getArenaRect() { return arena.getBoundingClientRect() }

// --------------------------------------------------------
// COORDINATES
// These function each return an object with x, y keys.

function coordOrigin() {
  return {
    x: 0,
    y: 0
  }
}

function coordSubtract(coord1, coord2) {
  const result = {
    x: coord1.x - coord2.x,
    y: coord1.y - coord2.y
  }
  return result
}

function coordAdd(coord1, coord2) {
  return {
    x: coord1.x + coord2.x,
    y: coord1.y + coord2.y
  }
}

function coordScalarMultiply(coord, multiplier) {
  return {
    x: coord.x * panMultiplier,
    y: coord.y * panMultiplier
  }
}

function coordFromEvent(ev) {
  return {
    x: ev.clientX,
    y: ev.clientY
  }
}

function coordFromTransformedElement(element) {
  // FROM: https://zellwk.com/blog/css-translate-values-in-javascript/
  const style = window.getComputedStyle(element)
  const matrix = style['transform'] || style.webkitTransform || style.mozTransform
  console.log({matrix})
  // No transform property. Simply return 0 values.
  if (matrix === 'none' || typeof matrix === 'undefined') {
    return coordOrigin()
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
    }
  }
  // 3d matrices have 16 values
  // The 13th, 14th, and 15th values are X, Y, and Z
  if (matrixType === '3d') {
    return {
      x: Number(matrixValues[12]),
      y: Number(matrixValues[13]),
    }
  }
}

// --------------------------------------------------------
// FUNCTIONS

function zoomIn() {
  console.log(coordFromTransformedElement(world))
  gsap.to(world, {
    scale: "+=.1",
    onComplete: () => coordFromTransformedElement(world)
  })
}

function zoomOut() {
  console.log(coordFromTransformedElement(world))
  gsap.to(world, {
    scale: "-=.1",
    onComplete: () => coordFromTransformedElement(world)
  })
}

function getScales() {
  // Basically, how much bigger is the arena/world than the window?
  const windowSize = {x: window.innerWidth, y: window.innerHeight}
  const arenaRect = getArenaRect()
  const arenaSize = { x: arenaRect.width, y: arenaRect.height}
  return {
    x: windowSize.x / arenaSize.x,
    y: windowSize.y / arenaSize.y
  }
}

const getScalesAsArray = () => Object.values(getScales())
const getMinScale = () => Math.min(...getScalesAsArray())
const getMaxScale = () => Math.max(...getScalesAsArray())

function fitArena() {
  gsap.set(world, {
    scale: 1 
  })
  const worldContainer = document.getElementById("worldContainer")
  const relCoord = MotionPathPlugin.getRelativePosition(worldContainer, arena, [0.5, 0.5], [0.5, 0.5])
  gsap.to(world, {
    scale: getMinScale(),
    x: "-=" + relCoord.x,
    y: "-=" + relCoord.y
  })
}

function pan(onComplete) {
  let panVector = coordSubtract(pointerCoord, atPanStart.pointerCoord)
  panVector = coordScalarMultiply(panVector, panMultiplier)
  const nextWorldCoord = coordAdd(atPanStart.worldCoord, panVector)
  gsap.to(world, {
    ...nextWorldCoord,
    ease: 'none',
    duration: .2,
    onComplete
  })
}

function coverWorldContainer() {
  const worldContainerRect = worldContainer.getBoundingClientRect()
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
    const currentWorldCoord = coordFromTransformedElement(world)
    gsap.to(world, {
      ...coordAdd(currentWorldCoord, panVector),
      ease: 'back',
      duration: .2
    })
  }
}

// --------------------------------------------------------
// EVENT HANDLERS

function pointerdown_handler(ev) {
  pointerCoord = coordFromEvent(ev)
  atPanStart = {
    worldCoord: coordFromTransformedElement(world),
    pointerCoord
  }
  panIntervalId = window.setInterval(pan, interval)
  worldContainer.setPointerCapture(ev.pointerId)
}

function pointermove_handler(ev) {
  if (panIntervalId) {
    pointerCoord = coordFromEvent(ev)
  }
}

function pointerup_handler(ev) {
  if (panIntervalId) {
    pan(coverWorldContainer)
    // Clear stuff
    clearInterval(panIntervalId)
    panIntervalId = null
    atPanStart = null
  }
}

// --------------------------------------------------------
// HOOKS

const WorldContainerPanZoom = {
  mounted() {
    // Set DOM references
    worldContainer = this.el
    world = document.getElementById("world")
    arena = document.getElementById("arena")
    // Set pointer event handlers
    worldContainer.onpointerdown = pointerdown_handler;
    worldContainer.onpointermove = pointermove_handler
    worldContainer.onpointerup = pointerup_handler;
    worldContainer.onpointercancel = pointerup_handler;
    worldContainer.onpointerout = pointerup_handler;
    worldContainer.onpointerleave = pointerup_handler;
  },
  destroyed() {
    worldContainer = null;
    world = null;
    arena = null;
  }
}

const ButtonFitArena = {
  mounted() {
    this.el.onclick = fitArena
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

export default { WorldContainerPanZoom, ButtonFitArena, ButtonZoomIn, ButtonZoomOut }
