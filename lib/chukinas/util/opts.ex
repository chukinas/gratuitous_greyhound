alias Chukinas.Util.Opts

defmodule Opts do

  def merge!(opts, default_opts) do
    Enum.reduce(opts, default_opts, fn {key, value}, new_opts ->
      Keyword.replace! new_opts, key, value
    end)
  end
end
