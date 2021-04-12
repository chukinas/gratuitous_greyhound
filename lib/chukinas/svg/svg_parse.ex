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
    |> IOP.inspect
    |> group_commands
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
    {cmd_group, rest} = Enum.split(terms, arg_count + 1) |> IOP.inspect
    rest = cond do
      not start_with_float(rest) -> rest
      # TODO clean this up
      "M" == command -> ["L" | rest]
      "m" == command -> ["l" | rest]
      "L" == command -> ["L" | rest]
      "l" == command -> ["l" | rest]
      true -> rest
    end
    [List.to_tuple(cmd_group) | group_commands(rest)]
  end

  def start_with_float([]), do: false
  def start_with_float([float | _]), do: is_float(float)

  def get_arg_count(command) when command in @command_with_0_arg, do: 0
  def get_arg_count(command) when command in @command_with_1_arg, do: 1
  def get_arg_count(command) when command in @command_with_2_arg, do: 2
  def get_arg_count(command) when command in @command_with_4_arg, do: 4
  def get_arg_count(command) when command in @command_with_6_arg, do: 6
  def get_arg_count(command) when command in @command_with_7_arg, do: 7
end
