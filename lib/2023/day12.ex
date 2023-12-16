{_, content} = File.read("./input/2023_12.txt")
SprintParseWorker.solve_in_parallel(content) |> IO.puts()
