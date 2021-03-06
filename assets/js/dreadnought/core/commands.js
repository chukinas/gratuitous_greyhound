// --------------------------------------------------------
// DATA

const active = {
  unitId: 2,
  stepId: 0,
}

// --------------------------------------------------------
// FUNCTIONS

function selectStep(stepId) {
  styleInactive(getSegmentEl())
  active.stepId = stepId
  styleActive(getSegmentEl())
}

function getSegmentEl() {
  const segmentElId = `segment-${active.unitId}-${active.stepId}`
  const el = document.getElementById(segmentElId)
  return el;
}

function styleInactive(el) {
  if (el) addRemoveClass(el, el.dataset.classInactive, el.dataset.classActive)
}

function styleActive(el) {
  if (el) addRemoveClass(el, el.dataset.classActive, el.dataset.classInactive)
}

function addRemoveClass(el, classesToAdd, classesToRemove) {
  classesToRemove.split(" ").forEach(className => {
    el.classList.remove(className)
  })
  classesToAdd.split(" ").forEach(className => {
    el.classList.add(className)
  })
}

function applyActiveOrInactiveStyling(el) {
  const activeSegmentEl = getSegmentEl()
  const activeSegmentElId = activeSegmentEl ? activeSegmentEl.id : null
  if (el.id == activeSegmentElId) {
    styleActive(el)
  } else {
    styleInactive(el)
  }
}

// --------------------------------------------------------
// EXPORT

export const Commands = { selectStep, applyActiveOrInactiveStyling }
