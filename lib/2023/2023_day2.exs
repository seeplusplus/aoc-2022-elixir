red_limit = 12
green_limit = 13
blue_limit = 14

parse_rounds = fn s ->
  s
  |> String.split(";")
  |> Enum.map(
    &Enum.map(
      String.split(&1, ","),
      fn x ->
        [_, count, color] = Regex.run(~r/(\d+) (.+)/, String.trim(x))
        {count, _} = count |> Integer.parse()
        color = color |> String.to_atom()

        {color, count}
      end
    )
  )
end

all_games =
  for line <- IO.stream(),
      line |> String.trim() |> String.length() > 0,
      [_, id, rounds] = Regex.run(~r/Game (\d+): (.+)/, line) do
    {id |> Integer.parse() |> elem(0), parse_rounds.(rounds)}
  end

part1 = fn games ->
  games
  |> Enum.filter(fn {_, games} ->
    Enum.all?(games, fn game ->
      game |> Keyword.get(:green, 0) <= green_limit &&
        game |> Keyword.get(:red, 0) <= red_limit &&
        game |> Keyword.get(:blue, 0) <= blue_limit
    end)
  end)
  |> Enum.map(&elem(&1, 0))
  |> Enum.sum()
end

part2 = fn games ->
  games
  |> Enum.map(
    &(elem(&1, 1)
      |> Enum.reduce(
        {0, 0, 0},
        fn round, {red, green, blue} ->
          {
            max(red, Keyword.get(round, :red, 0)),
            max(green, Keyword.get(round, :green, 0)),
            max(blue, Keyword.get(round, :blue, 0))
          }
        end
      ))
  )
  |> Enum.map(fn {x, y, z} -> x * y * z end)
  |> Enum.sum()
end

part2.(all_games) |> IO.puts()
