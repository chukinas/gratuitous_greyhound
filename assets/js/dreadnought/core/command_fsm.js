// --------------------------------------------------------
// DATA

// These vars store the currently active unit, card, and segment.
// They are all 1-indexed, so 0 indicates `no selection`.
// If a segment is active, that means it is in `preview` mode. I.e.,
// The playes will be shown a preview of what that card+segment choice will result in.
let UNITNUMBER = 0;
let CARDNUMBER = 0;
let SEGMENTNUMBER = 0;

// Finite State Machine state
let STATE = "noUnitSelected";

// --------------------------------------------------------
// API

// export function UnselectUnit() {
// 
// }
// 
// export function selectUnit(unitNumber) {
//   if unit
//   unitNumber = unitNumber
// }

// --------------------------------------------------------
// PRIVATE FUNCTIONS

