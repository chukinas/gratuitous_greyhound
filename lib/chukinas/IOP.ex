defmodule IOP do

  @opts [
    syntax_colors: [
      cust_struct: [:light_cyan, :bright],
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

  def inspect(term, label, opts \\ []) do
    opts = Keyword.merge([
      show_if: fn _x -> true end,
      only: nil
      #exclude: nil
    ], opts)
    if opts[:show_if].(term) do
      filtered_term = case opts[:only] do
        nil -> term
        key when not is_list(key) -> Map.take(term, [key])
        keys -> Map.take(term, keys)
      end
      IO.inspect(filtered_term, Keyword.merge(@opts, label: label))
    end
    term
  end

  def inspect(term) do
    IO.inspect(term, @opts)
  end
end

# I prefer to display maps as keyword lists.
# Control over the order
# Readability
# Inspect protocol so you don't have to label as much
