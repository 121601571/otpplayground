defmodule OtpCounter do
  use GenServer

    def init(state) do
      {:ok, state}
    end

    def handle_call({:add, value}, _from, state) do
      {:reply, state+value, state+value}
    end

    def handle_call({:get, dummy},_from, state) do
      {:reply, state, state}
    end

    #client call
    def start_link(state \\ 0 ) do
      GenServer.start_link(__MODULE__, state, name: __MODULE__)
    end

    def get(dummy \\ 0) do
      GenServer.call(__MODULE__, {:get, dummy})
    end

    def add(value) do
      GenServer.call(__MODULE__, {:add, value})
    end

end


defmodule BenchmarkTool do


  def runBench001(n) do
    1..n |> Enum.map( fn(x) -> Task.async(BenchmarkTool, :simpleFib, [50]) end )
  end


  def simpleFib(n) do
    if n < 3 do
      1
    else
      simpleFib(n-2) + simpleFib(n-1)
    end
  end


  def runBench002(n) do
    OtpCounter.start_link(0)
    IO.inspect(OtpCounter.get())
    times1 = div(n, 8)
    ll1 = getRange(1, n, times1)
    tasklist = ll1 |> Enum.map( fn(x) -> Task.async(BenchmarkTool, :getPrimeCount, [elem(x,0), elem(x,1)]) end )
    tasklist |> Enum.each(fn (x) ->  collectRes(x) end  )
    OtpCounter.get()
  end

  def collectRes(task1) do
    res = Task.await(task1, 100000000)
    OtpCounter.add(res)
    #IO.inspect(res)
  end

  def getRange(offset, total, times) do
    if offset > total do
      []
    else
      [{offset, Enum.min([offset + times,total])}] ++ getRange(offset+1 + times, total, times)
    end

  end

  def getPrimeCount(l,r) do
    l..r|> Enum.filter(fn(x) -> isPrime(x) end) |> Enum.count
  end

  defp isPrime(n) when n == 1 do
    false
  end

  defp isPrime(n) do
    2..n-1 |> Enum.all?(fn(x) -> rem(n, x) != 0 end)
  end

end
# a = BenchmarkTool.runBench001(100)
# a |> Enum.each(fn (x) ->  Task.await(x, 100000) end )
res = BenchmarkTool.runBench002(10000000)
IO.inspect(res)
#IO.inspect(BenchmarkTool.getPrimeCount(1,100000))
# OtpCounter.start_link(0)
# OtpCounter.add(10)
# OtpCounter.add(10)
# res = OtpCounter.get()
# IO.inspect(res)
