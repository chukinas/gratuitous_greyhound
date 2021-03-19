// --------------------------------------------------------
// DATA

// Global vars to cache event state
const gsap = window.gsap
let isPanning = false
let elementCoord = { x: 0, y: 0 }
let elementCoordAtStartOfPan = elementCoord
let pointerCoordAtStartOfPan = null
const panMultiplier = 1.5
// TODO move all vars into atPanStart that are calculated only at pan start
let atPanStart = {
  scale: null // window size / arena size
}

// --------------------------------------------------------
// FUNCTIONS BOUND TO MOUNTED ELEMENT

// Event Logger
// let logToElixir = () => {}

// Pan Element
let panElement = null

// --------------------------------------------------------
// FUNCTIONS

// function log(title, ev) {
//   logToElixir({
//     type: title,
//     pointerId: ev.pointerId,
//     pointerType: ev.pointerType,
//     isPrimary: ev.isPrimary,
//     coord: [ev.clientX, ev.clientY]
//   })
// } 

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

function getWorld() { return document.getElementById("world") }
function getWorldRect() { return getWorld().getBoundingClientRect() }
function getArena() { return document.getElementById("arena-margin") }
function getArenaRect() { return getArena().getBoundingClientRect() }

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
  const world = getWorld()
  gsap.set(world, {
    scale: 1 
  })
  const semiwindow = document.getElementById("semiwindow")
  const relCoord = MotionPathPlugin.getRelativePosition(semiwindow, getArena(), [0.5, 0.5], [0.5, 0.5])
  gsap.to(world, {
    scale: getMinScale(),
    x: "-=" + relCoord.x,
    y: "-=" + relCoord.y
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
  isPanning = true
  const rect = getWorldRect()
  elementCoordAtStartOfPan = { 
    x: rect.x,
    y: rect.y,
  }
  pointerCoordAtStartOfPan = coordFromEvent(ev)
  getWorld().setPointerCapture(ev.pointerId)
}

function pointermove_handler(ev) {
  if (!isPanning) return;
  const panVector = coordSubtract(coordFromEvent(ev), pointerCoordAtStartOfPan)
  const multipliedPanVector = coordMultiply(panVector, panMultiplier)
  elementCoord = coordAdd(elementCoordAtStartOfPan, multipliedPanVector)
  panElement(elementCoord)
  // logToElixir("panning!", ev)
}

function pointerup_handler(ev) {
  if (!isPanning) return;
  elementCoordAtStartOfPan = elementCoord
  isPanning = false
  getWorld().releasePointerCapture(ev.pointerId)
}

// --------------------------------------------------------
// HOOKS

const Pan = {
  mounted() {
    const me = this
    const el = this.el
    // Install event handlers for the pointer target
    el.onpointerdown = pointerdown_handler;
    el.onpointermove = pointermove_handler
    // Use same handler for pointer{up,cancel,out,leave} events since
    // the semantics for these events - in this app - are the same.
    el.onpointerup = pointerup_handler;
    el.onpointercancel = pointerup_handler;
    el.onpointerout = pointerup_handler;
    el.onpointerleave = pointerup_handler;
    panElement = (elementCoord) => {
      const coord = limitPan(elementCoord)
      window.gsap.to(el, { ...coord, duration: .25})
    }
  }
}

const RefitArena = {
  mounted() {
    this.el.onclick = resize
  }
}

const PrintCoordinates = {
  mounted() {
    this.el.onclick = () => console.log("testing")
  }
}

export default { Pan, RefitArena, PrintCoordinates }
