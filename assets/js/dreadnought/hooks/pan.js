// --------------------------------------------------------
// DATA

// Global vars to cache event state
const gsap = window.gsap
let isPanning = false
let elementCoord = { x: 0, y: 0 }
const panMultiplier = 1.5
// TODO move all vars into atPanStart that are calculated only at pan start
let atPanStart = {
  elementCoord: null,
  pointerCoord: null,
  scale: null // window size / arena size
}

// --------------------------------------------------------
// DOM REFERENCES

let worldContainer
let world
let arena

function getWorldRect() { return world.getBoundingClientRect() }
function getArenaRect() { return arena.getBoundingClientRect() }

// --------------------------------------------------------
// COORDINATES

function coordFromEvent(ev) {
  return {
    x: ev.clientX,
    y: ev.clientY
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

function coordMultiply(coord, multiplier) {
  return {
    x: coord.x * panMultiplier,
    y: coord.y * panMultiplier
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

function resize() {
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

function pan(elementCoord) {
  const coord = limitPan(elementCoord)
  window.gsap.to(world, { ...coord, duration: .25})
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
  isPanning = true
  const rect = getWorldRect()
  atPanStart.elementCoord= { 
    x: rect.x,
    y: rect.y,
  }
  atPanStart.pointerCoord= coordFromEvent(ev)
  worldContainer.setPointerCapture(ev.pointerId)
}

function pointermove_handler(ev) {
  if (!isPanning) return;
  console.log("move!")
  const panVector = coordSubtract(coordFromEvent(ev), atPanStart.pointerCoord)
  const multipliedPanVector = coordMultiply(panVector, panMultiplier)
  elementCoord = coordAdd(atPanStart.elementCoord, multipliedPanVector)
  pan(elementCoord)
}

function pointerup_handler(ev) {
  if (!isPanning) return;
  atPanStart.elementCoord= elementCoord
  isPanning = false
  worldContainer.releasePointerCapture(ev.pointerId)
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

// TODO rename ButtonFitArena
const RefitArena = {
  mounted() {
    this.el.onclick = resize
  }
}

export default { WorldContainerPanZoom, RefitArena }
