contains_symbol = fn s ->
  match = Regex.match?(~r/[^\d.]/, s)
  match
end

grab_numbers = fn line ->
  Regex.scan(~r/\d+/, line, return: :index)
  |> Enum.map(fn [{index, len}] ->
    {index, len, line |> String.slice(index, len) |> Integer.parse() |> elem(0)}
  end)
end

part1 = fn s ->
  for [pre, curr, post] <-
        s
        |> Enum.reject(&(String.length(&1) == 0))
        |> then(fn x -> Enum.concat([""], x) end)
        |> Enum.chunk(3, 1)
        |> Enum.map(fn u -> Enum.map(u, &String.trim/1) end),
      [{index, length}] <- Regex.scan(~r/\d+/, curr, return: :index),
      contains_symbol.(String.slice(curr, max(index - 1, 0), length + 2)) ||
        contains_symbol.(String.slice(pre, max(index - 1, 0), length + 2)) ||
        contains_symbol.(String.slice(post, max(index - 1, 0), length + 2)),
      {number, _} = String.slice(curr, index, length) |> Integer.parse() do
    number
  end
  |> Enum.sum()
end

part2 = fn s ->
  for [pre, curr, post] <-
        s
        |> Enum.reject(&(String.length(&1) == 0))
        |> then(fn x -> Enum.concat([""], x) end)
        |> then(fn x -> Enum.concat(x, [""]) end)
        |> Enum.chunk(3, 1)
        |> Enum.map(fn u -> Enum.map(u, &String.trim/1) end),
      curr |> String.contains?("*"),
      [{gear_idx, _}] <- Regex.scan(~r/\*/, curr, return: :index),
      matches =
        grab_numbers.(pre) |> Enum.concat(grab_numbers.(post)) |> Enum.concat(grab_numbers.(curr)),
      valid_matches =
        matches
        |> Enum.filter(fn {m_idx, m_len, _} ->
          gear_idx in max(0, m_idx - 1)..(m_idx + m_len)
        end),
      valid_matches |> Enum.count() == 2,
      [{_, _, a}, {_, _, b}] = valid_matches do
    a * b
  end
  |> Enum.sum()
end

part2.(IO.stream()) |> IO.puts()
