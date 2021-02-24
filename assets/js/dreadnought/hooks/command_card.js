// --------------------------------------------------------
// CONSTANTS

// --------------------------------------------------------
// FUNCTIONS

function get_following_segments(unitNumber, segmentNumber) {
  // TODO I thought that dataset supplied numbers and int, not strings... Investigate
  const segmentInt = parseInt(segmentNumber)
  const selector = `[data-unit-number=\"${unitNumber}\"][data-segment-display]`;
  const allSegmentsForThisUnit = document.querySelectorAll(selector)
  const segmentsAsArray = Array.from(allSegmentsForThisUnit)
  const followingSegments = segmentsAsArray.filter(el => parseInt(el.dataset.segmentNumber) > segmentInt)
  return followingSegments;
}

// --------------------------------------------------------
// EVENT HANDLERS

function dragstart_handler(ev) {
  ev.dataTransfer.setData("text/plain", ev.target.id);
  // TODO JJC the effects are copy, move, link. Play with these.
  ev.dataTransfer.dropEffect = "link"
  console.log(`Just started dragging ${ev.target.id}!`)
}

function dragenter_handler(ev) {
  const commandCardId = ev.dataTransfer.getData("text/plain")
  console.log(`${commandCardId} just entered ${ev.target.id}...`)
  // ev.preventdefault()
}

function drop_handler(ev) {
  ev.preventDefault()
  const commandCardId = ev.dataTransfer.getData("text/plain")
  console.log(`${commandCardId} was just dropped on ${ev.target.id}!`)
}

// --------------------------------------------------------
// HOOKS

const CommandCard = {
  mounted() {
    this.el.addEventListener("dragstart", dragstart_handler);
  }
}

const CommandCardTarget = {
  mounted() {
    this.el.addEventListener("dragover", dragenter_handler)
    this.el.addEventListener("drop", drop_handler)
  }
}

const SegmentDroppable = {
  mounted() {
    this.el.addEventListener("dragover", dragenter_handler)
    this.el.addEventListener("mouseenter", function(event) {
      const el = event.target;
      const segmentNumber = el.dataset.segmentNumber
      console.table(segmentNumber)
      get_following_segments(el.dataset.unitNumber, el.dataset.segmentNumber)
    }); 
  },
}

export default { CommandCard, CommandCardTarget, SegmentDroppable }
