{_, content} = File.read("./input/2023_5.txt")
input = content |> String.split("\n") |> Mix.Tasks.Day5.parse()
Benchee.run(
  %{
    "day5_part2" => fn -> input |> Mix.Tasks.Day5.part2() end
  }
)

