// --------------------------------------------------------
// DATA

const active = {
  unitId: 0,
  stepId: 0,
  cmdId: 0
}

// --------------------------------------------------------
// API

export function selectStep(stepId) {
  console.table("active prior:", active)
  active.stepId = stepId
  console.table("active after:", active)
}

// --------------------------------------------------------
// PRIVATE FUNCTIONS

