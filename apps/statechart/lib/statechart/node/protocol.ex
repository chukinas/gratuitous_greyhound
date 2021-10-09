defprotocol Statechart.Node.Protocol do

  def moniker(node)
  def next_default!(node)
  def enter_actions(node)
  def exit_actions(node)

end
