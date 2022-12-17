defmodule BenchmarkTool2 do

  def start(n) do
    ll = for x <- 1..n do x end
    ll
    |> Task.async_stream(fn(number) -> simpleN(number) end, timeout: 9999999, max_concurrency: 8)
    |> Enum.to_list()
  end

  defp simpleN(n) do
    if n < 3 do
      1
    else
      simpleN(n-2) + simpleN(n-1)
    end
  end

end
res = BenchmarkTool2.start(100)
IO.inspect(res)
