// --------------------------------------------------------
// CONSTANTS

// --------------------------------------------------------
// FUNCTIONS

function dragstart_handler(ev) {
  ev.dataTransfer.setData("text/plain", ev.target.id);
  // TODO JJC the effects are copy, move, link. Play with these.
  ev.dataTransfer.dropEffect = "link"
  console.log(`Just started dragging ${ev.target.id}!`)
}

function dragover_handler(ev) {
  const commandCardId = ev.dataTransfer.getData("text/plain")
  console.log(`${commandCardId} might be dropped on ${ev.target.id}...`)
  ev.preventDefault()
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
    this.el.addEventListener("drop", drop_handler)
    this.el.addEventListener("dragover", dragover_handler)
  }
}

export default { CommandCard, CommandCardTarget }
