alias Chukinas.Util.Opts

defmodule Opts do

  def merge!(opts, default_opts) do
    Enum.reduce(opts, default_opts, fn opt, new_opts ->
      Keyword.replace! new_opts, opt
    end)
  end
end
