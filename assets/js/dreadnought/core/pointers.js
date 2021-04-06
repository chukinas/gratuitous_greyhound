// --------------------------------------------------------
// DATA

// Save the pointer down event for each pointer id
const initialEvents = new Map();
// Save the latest event for each pointer id
const currentEvents = new Map();

let panCallback = () => { console.log("panning!")}
let pinchZoomCallback = () => { console.log("pinching!!") } 

// --------------------------------------------------------
// FUNCTIONS

function setPanCallback(callback) { panCallback = callback }
function setPinchZoomCallback(callback) { pinchZoomCallback = callback }

function down(pointerEvent) {
  const pointerId = pointerEvent.pointerId
  if (pointerId > 1) return;
  initialEvents.set(pointerId, pointerEvent)
  currentEvents.set(pointerId, pointerEvent)
}

function move(pointerEvent) {
  const pointerId = pointerEvent.pointerId
  if (initialEvents.has(pointerId)) {
    currentEvents.set(pointerId, pointerEvent)
  }
}

function up(pointerEvent) {
  if (pointerEvent.isPrimary) {
    initialEvents.clear()
    currentEvents.clear()
  } else {
    const pointerId = pointerEvent.pointerId
    initialEvents.delete(pointerId)
    currentEvents.delete(pointerId)
  }
}

function isActive() {
  const result = initialEvents.size > 0
  console.log("Pointer.isActive =", result)
  return result;
}

function applyCallback() {
  if (initialEvents.has(1)) {
    pinchZoomCallback()
  } else if (initialEvents.has(0)) {
    panCallback()
  }
}

// --------------------------------------------------------
// API

export const PointerEvents = {
  setPanCallback,
  setPinchZoomCallback,
  down,
  move,
  up,
  isActive,
}
