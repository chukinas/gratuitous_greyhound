// --------------------------------------------------------
// CONSTANTS

// --------------------------------------------------------
// FUNCTIONS

function dragstart_handler(ev) {
  ev.dataTransfer.setData("text/plain", ev.target.id);
}

// --------------------------------------------------------
// HOOKS

const CommandCard = {
  mounted() {
    this.el.addEventListener("dragstart", dragstart_handler);
  }
}

export default { CommandCard }
