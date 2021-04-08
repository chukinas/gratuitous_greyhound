import { Coord } from './coordinates.js'

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

// TODO rename downThenIsPrimary
function down(pointerEvent) {
  console.log("Pointer.down")
  const pointerId = pointerEvent.pointerId
  if (pointerId > 1) return false;
  initialEvents.set(pointerId, pointerEvent)
  currentEvents.set(pointerId, pointerEvent)
  return pointerEvent.isPrimary;
}

function move(pointerEvent) {
  //console.log("move", pointerEvent)
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
    panCallback(
      Coord.fromEvent(initialEvents.get(0)),
      Coord.fromEvent(currentEvents.get(0))
    )
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
