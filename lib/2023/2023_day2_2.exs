max = %{"red" => 12, "green" => 13, "blue" => 14}

is_valid_pull = fn {count, color} ->
  count <= max[color]
end

for {id, pulls} <-
      (for line <- IO.stream(),
           String.trim(line) != "",
           "Game " <> game = line,
           {id, ": " <> rest} = Integer.parse(game) do
         {id,
          for pull <- String.split(rest, "; ") |> Enum.map(&String.trim/1),
              cube <- String.split(pull, ", ") |> Enum.map(&String.trim/1),
              {count, color} = Integer.parse(cube),
              color = String.trim(color) do
            {count, color}
          end}
       end),
    Enum.all?(pulls, &is_valid_pull.(&1)) do
  id
end
|> Enum.sum()
|> IO.puts()
