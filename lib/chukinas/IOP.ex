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

  def inspect(term) do
    IO.inspect(term, @opts)
  end

alias Chukinas.Util.Opts
  def inspect(term, label, opts \\ []) do
    opts = Opts.merge!(opts, [
      show_if: fn _x -> true end,
      only: nil,
      disabled: false
      #exclude: nil
    ])
    if opts[:show_if].(term) and not opts[:disabled] do
      filtered_term = case opts[:only] do
        nil -> term
        key when not is_list(key) -> Map.take(term, [key])
        keys -> Map.take(term, keys)
      end
      IO.inspect(filtered_term, Keyword.merge(@opts, label: label))
    end
    term
  end

end

# I prefer to display maps as keyword lists.
# Inspect protocol so you don't have to label as much
# Note the IOP namespace. This is so that you can use it with minimal typing, no import)
# label convention: "Module-name function-name", b/c no need to actually say what it is, typically, since the inspect protocol tells me that.
# Things I havent't played with yet: turn into a macro that compiles to nothing in PROD
