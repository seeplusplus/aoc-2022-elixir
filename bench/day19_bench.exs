{_, puzzle_input} = File.read("./input/2023_19.txt")

{commands, _} = Mix.Tasks.Day19.parse(puzzle_input, &Mix.Tasks.Day19.build_range_comparator/1)

Benchee.run(%{
  "day19_part2" => fn -> Mix.Tasks.Day19.solve_part_2(commands) end
})

#Name                  ips        average  deviation         median         99th %
#day19_part2        1.47 K      681.65 μs    ±25.77%      603.99 μs     1300.13 μs
