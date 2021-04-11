defmodule Chukinas.Svg.Parse do
  @moduledoc"""
  Parse svg strings
  """

  def parse(svg_string) do
    svg_string
    |> String.split([" ", ","], trim: true)
    |> Stream.flat_map(&separate_terms/1)
    |> Enum.filter(& not is_nil &1)
  end

  def separate_terms(nil), do: [nil]
  def separate_terms(""), do: [nil]
  # def separate_terms(list) when is_list(list) do
  #   list
  # end
  def separate_terms(<<command::binary-size(1), rest::binary>>)
      when command in ~w(M m L l H h V v Z z C c S s Q q T t A a) do
    [command | separate_terms(rest)]
  end
  def separate_terms(term) do
    {float, binary} = Float.parse(term)
    [float | separate_terms(binary)]
  end
end
