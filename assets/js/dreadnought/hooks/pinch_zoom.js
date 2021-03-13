// --------------------------------------------------------
// DATA

// Log events flag
let logToElixir = () => {}

// Global vars to cache event state
var evCache = new Map();
var prevDiff = -1;

// --------------------------------------------------------
// FUNCTIONS

function log(prefix, ev) {
  logToElixir({
    type: prefix,
    pointerId: ev.pointerId,
    pointerType: ev.pointerType,
    isPrimary: ev.isPrimary,
    coord: [ev.clientX, ev.clientY]
  })
} 

function pushToCache(ev) {
  evCache.set(ev.pointerId, ev);
}

function pointerdown_handler(ev) {
  // The pointerdown event signals the start of a touch interaction.
  // This event is cached to support 2-finger gestures
  pushToCache(ev)
  log("pointerDown", ev);
}

function pointermove_handler(ev) {
  // This function implements a 2-pointer horizontal pinch/zoom gesture. 
  //
  // If the distance between the two pointers has increased (zoom in), 
  // the taget element's background is changed to "pink" and if the 
  // distance is decreasing (zoom out), the color is changed to "lightblue".

  pushToCache(ev)
  log("moving!", ev)

 // If two pointers are down, check for pinch gestures
 if (evCache.size == 2) {
   // Calculate the distance between the two pointers
   const xCoords = Array.from(evCache.values()).map(ev => ev.clientX)
   const curDiff = Math.abs(xCoords[0] - xCoords[1])

   if (prevDiff > 0) {
     if (curDiff > prevDiff) {
       // The distance between the two pointers has increased
       log("Pinch moving OUT -> Zoom in", ev);
     }
     if (curDiff < prevDiff) {
       // The distance between the two pointers has decreased
       log("Pinch moving IN -> Zoom out",ev);
     }
   }

   // Cache the distance for the next move event 
   prevDiff = curDiff;
 }
}

function pointerup_handler(ev) {
  log(ev.type, ev);
  // Remove this pointer from the cache and reset the target's
  // background and border
  evCache.delete(ev.pointerId)
 
  // If the number of pointers down is less than two then reset diff tracker
  if (evCache.size < 2) prevDiff = -1;
}

// --------------------------------------------------------
// HOOKS

const PinchZoom = {
  mounted() {
    const me = this
    const el = this.el
    // Install event handlers for the pointer target
    el.onpointerdown = pointerdown_handler;
    el.onpointermove = pointermove_handler;
    // Use same handler for pointer{up,cancel,out,leave} events since
    // the semantics for these events - in this app - are the same.
    el.onpointerup = pointerup_handler;
    el.onpointercancel = pointerup_handler;
    el.onpointerout = pointerup_handler;
    el.onpointerleave = pointerup_handler;
    logToElixir = (params) => {
      me.pushEvent("log", params)
    }
    logToElixir({test: "TEST"})
  }
}

export default { PinchZoom }
