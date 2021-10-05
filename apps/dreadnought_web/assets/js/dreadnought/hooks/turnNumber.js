const {subscribeNewTurn, triggerNewTurn} = (function() {
  const subscriptionCallbacks = []
  const subscribeNewTurn = (callback) => {
    subscriptionCallbacks.push(callback)
  }
  const triggerNewTurn = () => {
    // console.log("triggering new turn!")
    subscriptionCallbacks.forEach(callback => {
      // console.log("calling a callback")
      callback()
    })
  }
  return {subscribeNewTurn, triggerNewTurn}
})()


// --------------------------------------------------------
// HOOKS

const TurnNumber = {
  // mount() {
  //   const el = this.el
  //   getTurnNumber = function() {
  //     return el.dataset.turnNumber
  //   }
  //   console.log("turn num mount", getTurnNumber())
  // },
  beforeUpdate() {
    // console.log("turn beforeUpdate")
  },
  updated() {
    triggerNewTurn()
  },
}

// --------------------------------------------------------
// EXPORTS

export {subscribeNewTurn}
export default { TurnNumber }
