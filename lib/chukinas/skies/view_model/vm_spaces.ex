defmodule Chukinas.Skies.ViewModel.Spaces do
  alias Chukinas.Skies.ViewModel.Space

  @type t :: [Space.t()]

  def build(spaces) do
    spaces
    |> Map.to_list()
    |> Enum.map(&Space.build/1)
  end
end

defmodule Chukinas.Skies.ViewModel.Space do
  defstruct [:x, :y, :lethal_level]
  @type t :: %__MODULE__{
    x: integer(),
    y: integer(),
    lethal_level: any()
  }
  @type coordinates :: {integer(), integer()}

  @spec build({coordinates(), any()}) :: t()
  def build({{x, y}, content}) do
    %__MODULE__{x: x, y: y, lethal_level: content}
  end
end
