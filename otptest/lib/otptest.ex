
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

defmodule Solution do
  @spec climb_stairs(n :: integer) :: integer
  def climb_stairs(n) do
    OtpCache.start_link()
    if n == 1 do
      1
    else
      if n == 2 do
        2
      else
        OtpCache.put(1,1)
        OtpCache.put(2,2)
        #climb_stairs(n - 1) + climb_stairs(n - 2)
        3..n |> Enum.each(fn (x)-> calc1(x) end)
        ans = OtpCache.get(n)
        ans
      end
    end

  end

  defp calc1(n) do
    v1 = OtpCache.get(n - 1)
    v2 = OtpCache.get(n-2)
    ans = v1 + v2
    OtpCache.put(n, ans)
    ans
  end
end

a = Solution.climb_stairs(10)
IO.inspect(a)

# OtpCache.start_link()
# OtpCache.put("key", "value")
# res = OtpCache.get("key")
# IO.inspect(res)
