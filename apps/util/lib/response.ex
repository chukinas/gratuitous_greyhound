defmodule Util.Response  do

  @type t :: :ok | {:error, reason :: String.t}

  def from_bool(true, _reason_if_false), do: :ok
  def from_bool(false, reason) when is_binary(reason), do: {:error, reason}

end
