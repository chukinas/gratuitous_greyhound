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
// COORDINATES

function primaryVector() {
  return Coord.subtract(
    Coord.fromEvent(currentEvents.get(pointerId.primary)),
    Coord.fromEvent(initialEvents.get(pointerId.primary))
  )
}

function secondaryVector() {
  return Coord.subtract(
    Coord.fromEvent(currentEvents.get(pointerId.secondary)),
    Coord.fromEvent(initialEvents.get(pointerId.secondary))
  )
}

function initialDistance() {
  return Coord.distance(
    Coord.fromEvent(initialEvents.get(pointerId.primary)),
    Coord.fromEvent(initialEvents.get(pointerId.secondary))
  )
}

function currentDistance() {
  return Coord.distance(
    Coord.fromEvent(currentEvents.get(pointerId.primary)),
    Coord.fromEvent(currentEvents.get(pointerId.secondary))
  )
}

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

function dispatchGesture() {
  const activePointerCount = initialEvents.size
  if (activePointerCount == 2) {
    const panVector = Coord.average(primaryVector(), secondaryVector())
    const zoom = currentDistance() / initialDistance()
    // callback.logToElixir({
    //   zoom
    // })
    callback.pinch(panVector, zoom)
  } else if (activePointerCount == 1) {
    callback.pan(primaryVector())
  }
}

// --------------------------------------------------------
// EVENT HANDLING

function down(ev) {
  console.log("Pointer.down")
  if (ev.isPrimary) {
    callback.logToElixir({
      title: "primary down!!!!",
    })
    // Pan
    resetData()
    pointerId.primary = ev.pointerId
    callback.setPositionAndZoom()
  } else if (pointerId.secondary == null) {
    callback.logToElixir({
      title: "secondary down!!!!",
    })
    // Pinch
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
    dispatchGesture()
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

export const Gestures = {
  setCallbacks,
  down,
  move,
  up,
}
