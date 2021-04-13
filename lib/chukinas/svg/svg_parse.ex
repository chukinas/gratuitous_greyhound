defmodule Chukinas.Svg.Parse do
  @moduledoc"""
  Parse svg strings
  """

  @command_with_0_arg ~w(Z z)
  @command_with_1_arg ~w(H h V v)
  @command_with_2_arg ~w(M m L l Q q T t)
  @command_with_4_arg ~w(S s)
  @command_with_6_arg ~w(C c)
  @command_with_7_arg ~w(A a)
  @commands ~w(M m L l H h V v Z z C c S s Q q T t A a)

  def parse(svg_string) do
    svg_string
    |> String.split([" ", ","], trim: true)
    |> Stream.flat_map(&separate_terms/1)
    |> Enum.filter(& not is_nil &1)
    |> group_commands
    |> coerce_absolute_cmd
    |> coerce_int
  end

  # TODO refactor to use head and tails
  def separate_terms(nil), do: [nil]
  def separate_terms(""), do: [nil]
  # def separate_terms(list) when is_list(list) do
  #   list
  # end
  def separate_terms(<<command::binary-size(1), rest::binary>>) when command in @commands do
    [command | separate_terms(rest)]
  end
  def separate_terms(term) do
    {float, binary} = Float.parse(term)
    [float | separate_terms(binary)]
  end

  def group_commands([]), do: []
  def group_commands([command | _] = terms) when command in @commands do
    arg_count = get_arg_count command
    {cmd_group, rest} = Enum.split(terms, arg_count + 1)
    rest = cond do
      not start_with_float?(rest) -> rest
      # TODO clean this up
      "M" == command -> ["L" | rest]
      "m" == command -> ["l" | rest]
      "L" == command -> ["L" | rest]
      "l" == command -> ["l" | rest]
      true -> rest
    end
    [cmd_group | group_commands(rest)]
  end

  def start_with_float?([]), do: false
  def start_with_float?([float | _]), do: is_float(float)

  # TODO ugly. refactor
  def get_arg_count(command) when command in @command_with_0_arg, do: 0
  def get_arg_count(command) when command in @command_with_1_arg, do: 1
  def get_arg_count(command) when command in @command_with_2_arg, do: 2
  def get_arg_count(command) when command in @command_with_4_arg, do: 4
  def get_arg_count(command) when command in @command_with_6_arg, do: 6
  def get_arg_count(command) when command in @command_with_7_arg, do: 7

  def coerce_absolute_cmd(cmd_groups) do
    coerce_absolute_cmd(cmd_groups, {0, 0})
  end
  def coerce_absolute_cmd([], _), do: []
  def coerce_absolute_cmd(["z"], _), do: ["Z"]
  def coerce_absolute_cmd(["Z"], _), do: ["Z"]
  def coerce_absolute_cmd([cmd_group | rest], start_coord) do
    new_cmd_group = add(cmd_group, start_coord)
    new_start_coord = get_end_point(new_cmd_group)
    [new_cmd_group | coerce_absolute_cmd(rest, new_start_coord)]
  end

  def add(["z"], {_x, _y}), do: ["Z"]
  def add(["h", dx], {x, y}), do: ["L", x + dx, y]
  def add(["H", dx], {_x, y}), do: ["L", dx, y]
  def add(["v", dy], {x, y}), do: ["L", x, y + dy]
  def add(["V", dy], {x, _y}), do: ["L", x, dy]
  def add(["l", dx, dy], {x, y}), do: ["L", x + dx, y + dy]
  def add(["m", dx, dy], {x, y}), do: ["M", x + dx, y + dy]
  #def add([cmd, vals], {x, y}) do
  #  new_vals =
  #    vals
  #    |> Enum.chunk_every(2)
  #    |> Enum.flat_map(fn [dx, dy] -> [x + dx, y + dy] end)
  #  [String.upcase(cmd) | new_vals]
  #end
  def add(already_abs, _), do: already_abs

  def get_end_point(["Z"]), do: {0, 0}
  def get_end_point([_, x, y]), do: {x, y}

  def coerce_int(val) when is_list(val), do: Enum.map(val, &coerce_int/1)
  def coerce_int(val) when is_binary(val), do: val
  def coerce_int(val) when is_float(val), do: round val
end
