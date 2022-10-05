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
end
a = BenchmarkTool.runBench001(100)
a |> Enum.each(fn (x) ->  Task.await(x, 100000) end )
