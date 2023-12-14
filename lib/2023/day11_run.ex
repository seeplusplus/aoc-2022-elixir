{_, puzzle_input} = File.read("./input/2023_11.txt")
IO.puts("part 1 #{Galaxy.solve_pt_1(puzzle_input)}")
IO.puts("part 2 #{Galaxy.shortest_paths_expansion_adjusted(puzzle_input, 10**6)}")
