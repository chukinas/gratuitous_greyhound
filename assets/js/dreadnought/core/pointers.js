import { Coord } from './coordinates.js'

// --------------------------------------------------------
// DATA

// Save the pointer down event for each pointer id
const initialEvents = new Map();
// Save the latest event for each pointer id
const currentEvents = new Map();

let primaryPointerId
let callback = {
  pan: () => console.log("pan callback!!!"),
  pinch: () => console.log("pinch callback!!!"),
  setPositionAndZoom: () => console.log("setPositionAndZoom callback!!!"),
  clearPositionAndZoom: () => console.log("clearPositionAndZoom callback!!!"),
}

// --------------------------------------------------------
// FUNCTIONS

function setCallbacks(callbacks) {
  callback = {
    ...callback,
    ...callbacks
  }
}

// TODO rename downThenIsPrimary
function down(pointerEvent) {
  console.log("Pointer.down")
  const pointerId = pointerEvent.pointerId
  if (pointerId > 1) return false;
  initialEvents.set(pointerId, pointerEvent)
  currentEvents.set(pointerId, pointerEvent)
  if (pointerEvent.isPrimary) {
    primaryPointerId = pointerEvent.pointerId
    return true
  }
  return false
}

function move(pointerEvent) {
  console.log("move", pointerEvent)
  const pointerId = pointerEvent.pointerId
  if (initialEvents.has(pointerId)) {
    currentEvents.set(pointerId, pointerEvent)
    applyCallback()
  }
}

function up(pointerEvent) {
  if (pointerEvent.isPrimary) {
    initialEvents.clear()
    currentEvents.clear()
    primaryPointerId = null
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
  const activePointerCount = initialEvents.size
  // TODO replace with case statement
  if (activePointerCount == 2) {
    callback.pinch()
  } else if (activePointerCount == 1) {
    callback.pan(
      Coord.fromEvent(initialEvents.get(primaryPointerId)),
      Coord.fromEvent(currentEvents.get(primaryPointerId))
    )
  }
}

// --------------------------------------------------------
// API

export const PointerEvents = {
  setCallbacks,
  down,
  move,
  up,
}
