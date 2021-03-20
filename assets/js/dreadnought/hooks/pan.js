// --------------------------------------------------------
// DATA

// Global vars to cache event state
const gsap = window.gsap
let panIntervalId
// TODO dynamically calculate
let panMultiplier = 1.5
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
  // No transform property. Simply return 0 values.
  if (matrix === 'none' || typeof matrix === 'undefined') {
    return {
      x: 0,
      y: 0,
    }
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

function debounce(func, wait, immediate) {
  var timeout;
  return function() {
    var context = this, args = arguments;
    var later = function() {
        timeout = null;
        if (!immediate) func.apply(context, args);
    };
    var callNow = immediate && !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) func.apply(context, args);
  }
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

function pan() {
  let panVector = coordSubtract(pointerCoord, atPanStart.pointerCoord)
  panVector = coordScalarMultiply(panVector, panMultiplier)
  const nextWorldCoord = coordAdd(atPanStart.worldCoord, panVector)
  window.gsap.to(world, {
    ...nextWorldCoord
  })
}

function limitPan(requestedCoord) {
  // Prevent user from seeing the body bg color at top-left
  let coord = {
    x: Math.min(0, requestedCoord.x),
    y: Math.min(0, requestedCoord.y)
  }
  // Prevent user from seeing the body bg color at bottom-right
  const rect = getWorldRect()
  if (rect.width >= window.innerWidth) {
    coord.x = Math.max(window.innerWidth - rect.width, coord.x)
  }
  if (rect.height >= window.innerHeight) {
    coord.y = Math.max(window.innerHeight - rect.height, coord.y)
  }
  return coord
}

// --------------------------------------------------------
// EVENT HANDLERS

function pointerdown_handler(ev) {
  atPanStart = {
    worldCoord: coordFromTransformedElement(world),
    pointerCoord: coordFromEvent(ev)
  }
  panIntervalId = window.setInterval(pan, 150)
  worldContainer.setPointerCapture(ev.pointerId)
}

function pointermove_handler(ev) {
  if (panIntervalId) {
    pointerCoord = coordFromEvent(ev)
  }
}

function pointerup_handler(ev) {
  if (panIntervalId) {
    pan()
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
    // TODO can I replace document with worldContainer?
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

export default { WorldContainerPanZoom, ButtonFitArena }
