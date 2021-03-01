defmodule IOP do

  @opts [
    syntax_colors: [
      number: :light_yellow,
      atom: :cyan,
      string: :yellow,
      boolean: :red,
      binary: :yellow,
      tuple: :yellow,
      map: [:light_cyan, :bright],
      nil: [:magenta, :bright]
    ]
  ]

  def inspect(term, label) do
    IO.inspect(term, Keyword.merge(@opts, label: label))
  end

  def inspect(term) do
    IO.inspect(term, @opts)
  end
end
