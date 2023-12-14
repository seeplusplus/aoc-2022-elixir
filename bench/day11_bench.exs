puzzle_input = BenchUtil.get_puzzle_input(2023, 11)

# {_, puzzle_input} = File.read("./input/2023_11.txt")
IO.puts("part 1 #{Galaxy.solve_pt_1(puzzle_input)}")
IO.puts("part 2 #{Galaxy.shortest_paths_expansion_adjusted(puzzle_input, 10**6)}")

Benchee.run(
  %{
    "day11_part2" => fn -> Galaxy.shortest_paths_expansion_adjusted(puzzle_input, 10**6) end
  }
)

