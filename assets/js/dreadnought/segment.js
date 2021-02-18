// --------------------------------------------------------
// CONSTANTS

const segmentDuration = 5; // seconds
const worldTimeline = gsap.timeline()
const segmentIds = []

// --------------------------------------------------------
// FUNCTIONS

// --------------------------------------------------------
// HOOKS

const Segment = {
  mounted() {
    segmentIds.push(this.el.id)
    console.log('just pushed new segment id to array...', segmentIds)
  }
}

export default { Segment }
