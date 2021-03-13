// --------------------------------------------------------
// DATA

// Global vars to cache event state
let isPanning = false
let elementCoord = { x: 0, y: 0 }
let pointerCoordAtStartOfPan = null

// --------------------------------------------------------
// FUNCTIONS BOUND TO MOUNTED ELEMENT

// Event Logger
let logToElixir = () => {}

// Pan Element
let panElement = null

// --------------------------------------------------------
// FUNCTIONS

function log(title, ev) {
  logToElixir({
    type: title,
    pointerId: ev.pointerId,
    pointerType: ev.pointerType,
    isPrimary: ev.isPrimary,
    coord: [ev.clientX, ev.clientY]
  })
} 

function coordFromEvent(ev) {
  return {
    x: ev.clientX,
    y: ev.clientY
  }
}

function coordSubtract(coord1, coord2) {
  console.log("sub coord1", coord1, coord2)
  const result = {
    x: coord1.x - coord2.x,
    y: coord1.y - coord2.y
  }
  console.log("sub result", result)
  return result
}

function coordAdd(coord1, coord2) {
  console.log("add coord1", coord1)
  return {
    x: coord1.x + coord2.x,
    y: coord1.y + coord2.y
  }
}

function pointerdown_handler(ev) {
  isPanning = true
  pointerCoordAtStartOfPan = coordFromEvent(ev)
  console.log("pointer down. coord:", pointerCoordAtStartOfPan)
  log("start pan", ev);
}

function pointermove_handler(ev) {
  if (!isPanning) return;
  const panVector = coordSubtract(coordFromEvent(ev), pointerCoordAtStartOfPan)
  console.log("pan vector", panVector)
  elementCoord = coordAdd(elementCoord, panVector)
  panElement(elementCoord)
  logToElixir("panning!", ev)
}

function pointerup_handler(ev) {
  log(ev.type, ev);
  isPanning = false
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
    el.onpointerup = pointerup_handler;
    el.onpointercancel = pointerup_handler;
    el.onpointerout = pointerup_handler;
    el.onpointerleave = pointerup_handler;
    logToElixir = (params) => {
      me.pushEvent("log", params)
    }
    logToElixir({test: "TEST"})
    panElement = (elementCoord) => {
      console.log("panning w/ gsap!", el)
      window.gsap.to(el, { ...elementCoord })
    }
  }
}

export default { Pan }
