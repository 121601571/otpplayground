defmodule Otptest do
  @moduledoc """
  Documentation for `Otptest`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Otptest.hello()
      :world

  """
  def hello do
    :world
  end
end


defmodule OtpCache do
  use GenServer

    def init(state) do
      {:ok, state}
    end

    def handle_call({:get, key}, _from, state) do
      {:reply, Map.get(state, key), state}
    end

    def handle_cast({:put, key, value}, state) do
      {:noreply, Map.put(state, key, value)}
    end

    #client call
    def start_link(state \\ Map.new ) do
      GenServer.start_link(__MODULE__, state, name: __MODULE__)
    end

    def get(key) do
      GenServer.call(__MODULE__, {:get, key})
    end

    def put(key, value) do
      GenServer.cast(__MODULE__, {:put, key, value})
    end

end

OtpCache.start_link()
OtpCache.put("key", "value")
res = OtpCache.get("key")
IO.inspect(res)
