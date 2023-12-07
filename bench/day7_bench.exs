{_, content} = File.read("./input/2023_7.txt")

Benchee.run(
  %{
    "day7_part2" => fn -> content |> String.split("\n") |> Stream.map(&String.trim/1) |> Mix.Tasks.Day7.solve() end
  }
)

