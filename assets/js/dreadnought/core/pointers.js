import { Coord } from './coordinates.js'

// --------------------------------------------------------
// DATA

let pointerId
let initialEvents
let currentEvents

function resetData() {
  initialEvents = new Map()
  currentEvents = new Map()
  pointerId = {
    primary: null,
    secondary: null,
  }
}
resetData()

// --------------------------------------------------------
// CALLBACKS

let callback = {
  pan: () => console.log("pan callback!!!"),
  pinch: () => console.log("pinch callback!!!"),
  setPositionAndZoom: () => console.log("setPositionAndZoom callback!!!"),
  clearPositionAndZoom: () => console.log("clearPositionAndZoom callback!!!"),
}

function setCallbacks(callbacks) {
  callback = {
    ...callback,
    ...callbacks
  }
}

function panOrPinch() {
  const activePointerCount = initialEvents.size
  // TODO replace with case statement
  if (activePointerCount == 2) {
    callback.pinch()
  } else if (activePointerCount == 1) {
    callback.pan(
      Coord.fromEvent(initialEvents.get(pointerId.primary)),
      Coord.fromEvent(currentEvents.get(pointerId.primary))
    )
  }
}

// --------------------------------------------------------
// GESTURES

function down(ev) {
  console.log("Pointer.down")
  if (ev.isPrimary) {
    resetData()
    pointerId.primary = ev.pointerId
    callback.setPositionAndZoom()
  } else if (pointerId.secondary == null) {
    pointerId.secondary = ev.pointerId
  } else {
    return
  }
  initialEvents.set(ev.pointerId, ev)
  currentEvents.set(ev.pointerId, ev)
}

function move(ev) {
  console.log("move", ev)
  if (initialEvents.has(ev.pointerId)) {
    currentEvents.set(ev.pointerId, ev)
    panOrPinch()
  }
}

function up(ev) {
  if (initialEvents.has(ev.pointerId)) {
    resetData()
    callback.clearPositionAndZoom()
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
