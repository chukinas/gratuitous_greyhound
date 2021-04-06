// --------------------------------------------------------
// DATA

// Save the pointer down event for each pointer id
const initialEvents = new Map();
// Save the latest event for each pointer id
const currentEvents = new Map();

// --------------------------------------------------------
// FUNCTIONS

function down(pointerEvent) {
  const pointerId = pointerEvent.pointerId
  if (pointerId > 1) return;
  if (!initialEvents.has(pointerId)) {
    initialEvents.set(pointerId, pointerEvent)
  }
  currentEvents.set(pointerId, pointerEvent)
}

function move(pointerEvent) {
  const pointerId = pointerEvent.pointerId
  if (pointerId > 1) return;
  if (!initialEvents.has(pointerId)) {
    initialEvents.set(pointerId, pointerEvent)
  }
  currentEvents.set(pointerId, pointerEvent)
}

function up(pointerEvent) {
  const pointerId = pointerEvent.pointerId
  initialEvents.delete(pointerId)
  currentEvents.delete(pointerId)
}

function isActive() {
  const result = initialEvents.size > 0
  console.log("Pointer.isActive =", result)
  return result;
}

// --------------------------------------------------------
// API

export const PointerEvents = {
  down,
  move,
  up,
  isActive,
}
