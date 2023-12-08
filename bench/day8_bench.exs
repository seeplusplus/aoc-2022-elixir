{_, puzzle_input} = File.read("./input/2023_8.txt")

Benchee.run(
  %{
    "day8_part2" => fn -> Mix.Tasks.Day8.solve(puzzle_input, :part2) end
  }
)

