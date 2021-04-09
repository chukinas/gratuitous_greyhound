import { Coord } from './coordinates.js'

// --------------------------------------------------------
// DATA

let pointerId
let initialEvents
let currentEvents
let intervalId

function resetData() {
  initialEvents = new Map()
  currentEvents = new Map()
  pointerId = {
    primary: null,
    secondary: null,
  }
  intervalId = null
}

resetData()

// --------------------------------------------------------
// GESTURE

const INTERVAL = 300 // pan debounce interval (ms)

function startGesture() {
  resetData()
  callback.setPositionAndZoom()
  intervalId = window.setInterval(_dispatchGesture, INTERVAL)
}

function stopGesture() {
  clearInterval(intervalId)
  _dispatchGesture()
  resetData()
  callback.clearPositionAndZoom()
}

function _dispatchGesture() {
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

// --------------------------------------------------------
// EVENT HANDLING

function down(ev) {
  if (ev.isPrimary) {
    startGesture()
    pointerId.primary = ev.pointerId
  } else if (pointerId.secondary == null) {
    pointerId.secondary = ev.pointerId
  } else {
    return
  }
  initialEvents.set(ev.pointerId, ev)
  currentEvents.set(ev.pointerId, ev)
}

function move(ev) {
  if (initialEvents.has(ev.pointerId)) {
    currentEvents.set(ev.pointerId, ev)
  }
}

function up(ev) {
  if (initialEvents.has(ev.pointerId)) {
    stopGesture()
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
