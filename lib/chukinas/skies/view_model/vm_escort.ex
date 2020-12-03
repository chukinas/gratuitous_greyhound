defmodule Chukinas.Skies.ViewModel.Escort do

  # TODO move this to a template

  import Phoenix.HTML

  def render() do
    ~E"""
    <div class="
      border-2
      border-green-800
      bg-green-400
      text-green-800
      w-20
      h-20
      p-4
      font-bold
      rounded-xl
      text-base
      text-center
      align-middle
    ">S (<%= 6 %>)</div>
    """
  end
end
