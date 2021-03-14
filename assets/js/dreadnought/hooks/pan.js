// --------------------------------------------------------
// DATA

// Global vars to cache event state
let isPanning = false
let elementCoord = { x: 0, y: 0 }
let elementCoordAtStartOfPan = elementCoord
let pointerCoordAtStartOfPan = null

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

function resize() {
  // Set scale back to zero
  window.elWorld = document.getElementById("world")
  window.elArenaMargin = document.getElementById("arena-margin")
  window.rectArena = elArenaMargin.getBoundingClientRect()
  window.gsap.set(window.elWorld, {
    scale: 1
  })
  const windowSize = {x: window.innerWidth, y: window.innerHeight}
  const windowAspectRatio = windowSize.x / windowSize.y
  rectArena = elArenaMargin.getBoundingClientRect()
  const arenaSize = { x: rectArena.width, y: rectArena.height}
  const arenaAspectRatio = 1
  let scale
  if (windowAspectRatio > arenaAspectRatio) {
    // Fit on height
    scale = windowSize.y / arenaSize.y
    
  } else {
    // Fit on width
    scale = windowSize.x / arenaSize.x
  }
  window.gsap.set(elWorld, {
    scale,
    x: 0,
    y: 0
  })
  rectArena = elArenaMargin.getBoundingClientRect()
  window.gsap.to(elWorld, {
    x: "+=" + (-rectArena.x + (window.innerWidth - rectArena.width)/2),
    y: "+=" + (-rectArena.y + (window.innerHeight - rectArena.height)/2),
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
  elementCoord = coordAdd(elementCoordAtStartOfPan, panVector)
  panElement(elementCoord)
  // logToElixir("panning!", ev)
}

function pointerup_handler(ev) {
  elementCoordAtStartOfPan = elementCoord
  // log(ev.type, ev);
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
    el.onpointermove = pointermove_handler;
    // Use same handler for pointer{up,cancel,out,leave} events since
    // the semantics for these events - in this app - are the same.
    const debouncedPointerUpHandler = debounce(pointerup_handler, 250)
    el.onpointerup = debouncedPointerUpHandler;
    el.onpointercancel = debouncedPointerUpHandler;
    el.onpointerout = debouncedPointerUpHandler;
    el.onpointerleave = debouncedPointerUpHandler;
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

export default { Pan, RefitArena }
