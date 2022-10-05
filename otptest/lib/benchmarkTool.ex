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
    times1 = div(n, 8)
    ll1 = getRange(1, n, times1)
    tasklist = ll1 |> Enum.map( fn(x) -> Task.async(BenchmarkTool, :getPrimeCount, [elem(x,0), elem(x,1)]) end )
    tasklist |> Enum.each(fn (x) ->   IO.inspect(Task.await(x, 100000) ) end )
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
res = BenchmarkTool.runBench002(1000000)
IO.inspect(res)
# IO.inspect(BenchmarkTool.getPrimeCount(1,1000))
