// --------------------------------------------------------
// DATA

// Global vars to cache event state
let cat
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

function pointerdown_handler(ev) {
  isPanning = true
  pointerCoordAtStartOfPan = coordFromEvent(ev)
  // log("start pan", ev);
  cat.setPointerCapture(ev.pointerId)
  console.log("DOWN")
}

function pointermove_handler(ev) {
  if (!isPanning) return;
  console.log("MOVE")
  const panVector = coordSubtract(coordFromEvent(ev), pointerCoordAtStartOfPan)
  elementCoord = coordAdd(elementCoordAtStartOfPan, panVector)
  panElement(elementCoord)
  // logToElixir("panning!", ev)
}

function pointerup_handler(ev) {
  pointermove_handler(ev)
  elementCoordAtStartOfPan = elementCoord
  // log(ev.type, ev);
  console.log("UP")
  isPanning = false
  cat.releasePointerCapture(ev.pointerId)
}

// --------------------------------------------------------
// HOOKS

const Pan = {
  mounted() {
    const me = this
    const el = this.el
    cat = el
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
    // logToElixir = (params) => {
    //   const browser = navigator.userAgent
    //   me.pushEvent("log", { ...params, browser })
    // }
    // logToElixir({test: "TEST"})
    panElement = (elementCoord) => {
      console.log("PAN", elementCoord)
      window.gsap.to(el, { ...elementCoord, duration: .25})
    }
  }
}

export default { Pan }
