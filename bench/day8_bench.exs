puzzle_input_for_day = fn (year, day) ->
  {_, puzzle_input} = File.read("./input/#{year}_#{day}.txt")
  puzzle_input
end

Benchee.run(
  %{
    "day8_part2" => {fn input -> Mix.Tasks.Day8.solve(input, :part2) end, before_scenario: fn _ -> puzzle_input_for_day.(2023, 8) end},
    "day9_part1" => {fn input -> Mix.Tasks.Day9.solve(input, :part1) end, before_scenario: fn _ -> puzzle_input_for_day.(2023, 9) end},
    "day9_part2" => {fn input -> Mix.Tasks.Day9.solve(input, :part2) end, before_scenario: fn _ -> puzzle_input_for_day.(2023, 9) end},
  }
)

