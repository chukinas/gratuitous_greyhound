defmodule Chukinas.Rooms do
  use GenServer

  #############################################################################
  # CLIENT API
  #############################################################################

  @doc """
  Start the registry.
  """
  def start_link(_ops) do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  # @doc """
  # Looks up the bucket pid for `name` stored in `server`.

  # Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  # """
  # def lookup(server, name) do
  #   GenServer.call(server, {:lookup, name})
  # end

  # @doc """
  # Ensures there is a bucket associated with the given `name` in `server`.
  # """
  # def create(server, name) do
  #   GenServer.cast(server, {:create, name})
  # end

  #############################################################################
  # SERVER CALLBACKS
  #############################################################################

  @impl true
  def init(_) do
    # names = %{}
    # refs = %{}
    # {:ok, {names, refs}}
    # :timer.send_interval(1000, :tick)
    {:ok, 0}
  end

  # @impl true
  # def handle_call({:lookup, name}, _from, state) do
  #   {names, _} = state
  #   {:reply, Map.fetch(names, name), state}
  # end

  # @impl true
  # def handle_cast({:create, name}, {names, refs}) do
  #   if Map.has_key?(names, name) do
  #     {:noreply, {names, refs}}
  #   else
  #     {:ok, bucket} = KV.Bucket.start_link([])
  #     ref = Process.monitor(bucket)
  #     refs = Map.put(refs, ref, name)
  #     names = Map.put(names, name, bucket)
  #     {:noreply, {names, refs}}
  #   end
  # end

  @impl true
  def handle_info(:tick, count) do
    {:noreply, count + 1}
  end

  # @impl true
  # def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
  #   {name, refs} = Map.pop(refs, ref)
  #   names = Map.delete(names, name)
  #   {:noreply, {names, refs}}
  # end

  # @impl true
  # def handle_info(_msg, state) do
  #   {:noreply, state}
  # end
end
