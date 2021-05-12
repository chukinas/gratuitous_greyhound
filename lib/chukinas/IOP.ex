# iop.ex

defmodule IOP do

  alias Inspect.Algebra
  require Inspect.Algebra

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

  def inspect(term, label \\ nil) do
    IO.puts ""
    IO.inspect(term, Keyword.merge(@opts, label: label))
  end

  defmacro color(term) do
    quote do
      Algebra.color(unquote(term), :map, var!(opts))
    end
  end

  defmacro doc(term) do
    quote do
      Algebra.to_doc(unquote(term), var!(opts))
    end
  end

  defmacro comma do
    quote do
      IOP.color(",")
    end
  end

  defmacro struct(title, fields) do
    quote do
      Algebra.concat [
        IOP.color("##{unquote(title)}<"),
        IOP.doc(unquote(fields)),
        IOP.color(">")
      ]
    end
  end

  defmacro container(title, inner) when is_binary(title) do
    quote do
      IOP.color("##{unquote(title)}<")
      |> Algebra.glue("", unquote(inner))
      |> Algebra.nest(2)
      |> Algebra.glue("", IOP.color(">"))
      |> Algebra.group
    end
  end

#alias Chukinas.Util.Opts
#  def inspect(term, label, opts \\ []) do
#    opts = Opts.merge!(opts, [
#      show_if: fn _x -> true end,
#      only: nil,
#      disabled: false
#      #exclude: nil
#    ])
#    if opts[:show_if].(term) and not opts[:disabled] do
#      filtered_term = case opts[:only] do
#        nil -> term
#        key when not is_list(key) -> Map.take(term, [key])
#        keys -> Map.take(term, keys)
#      end
#      IO.inspect(filtered_term, Keyword.merge(@opts, label: label))
#    end
#    term
#  end

end

# I prefer to display maps as keyword lists.
# Inspect protocol so you don't have to label as much
# Note the IOP namespace. This is so that you can use it with minimal typing, no import)
# label convention: "Module-name function-name", b/c no need to actually say what it is, typically, since the inspect protocol tells me that.
# Things I havent't played with yet: turn into a macro that compiles to nothing in PROD
