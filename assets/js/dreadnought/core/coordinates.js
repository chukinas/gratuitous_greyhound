function build(x, y) {
  return {
    x,
    y
  }
}

function origin() {
  return {
    x: 0,
    y: 0
  }
}

function subtract(coord1, coord2) {
  const result = {
    x: coord1.x - coord2.x,
    y: coord1.y - coord2.y
  }
  return result
}

function add(coord1, coord2) {
  return {
    x: coord1.x + coord2.x,
    y: coord1.y + coord2.y
  }
}

function multiply(coord, multiplier) {
  return {
    x: coord.x * multiplier,
    y: coord.y * multiplier
  }
}

function average(coord1, coord2) {
  return {
    x: ((coord1.x + coord2.x) / 2),
    y: ((coord1.y + coord2.y) / 2)
  }
}

function distance(coord1, coord2) {
  const diff = subtract(coord1, coord2)
  return Math.sqrt(
    diff.x * diff.x,
    diff.y * diff.y,
  )
}

function fromEvent(ev) {
  return {
    x: ev.clientX,
    y: ev.clientY
  }
}

function isApproxZero(coord) {
  return Math.abs(coord.x) < 1 & Math.abs(coord.y) < 1
}

function toString(coord) {
  return `${coord.x}px ${coord.y}px`
}

// --------------------------------------------------------
// API

export const Coord = {
  origin,
  add,
  subtract,
  multiply,
  average,
  distance,
  fromEvent,
  isApproxZero,
  build,
  toString
}
