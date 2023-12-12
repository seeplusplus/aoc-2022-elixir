{_, content} = File.read("./input/2023_5.txt")

Benchee.run(
  %{
    "day5_part2" => fn -> content |> String.split("\n") |> Mix.Tasks.Day5.parse() |> Mix.Tasks.Day5.part2() end
  }
)

