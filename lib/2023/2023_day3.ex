import RegexUtil, only: [scan_index_with_binary: 2]

defmodule Mix.Tasks.Day3 do
  use Mix.Task

  @r_digits ~r/\d+/

  def run(_) do
    part2(IO.stream()) |> IO.puts()
  end

  def contains_symbol(s) do
    Regex.match?(~r/[^\d.]/, s)
  end

  def part1(s) do
    for [pre, curr, post] <-
          s
          |> then(fn x -> Enum.concat([""], x) end)
          |> Enum.chunk(3, 1)
          |> Enum.map(fn u -> Enum.map(u, &String.trim/1) end),
        [{index, length}] <- Regex.scan(@r_digits, curr, return: :index),
        contains_symbol(String.slice(curr, max(index - 1, 0), length + 2)) ||
          contains_symbol(String.slice(pre, max(index - 1, 0), length + 2)) ||
          contains_symbol(String.slice(post, max(index - 1, 0), length + 2)),
        {number, _} = String.slice(curr, index, length) |> Integer.parse() do
      number
    end
    |> Enum.sum()
  end

  def part2(s) do
    for [pre, curr, post] <-
          s
          |> Enum.chunk(3, 1)
          |> Enum.map(fn u -> Enum.map(u, &String.trim/1) end),
        curr |> String.contains?("*"),
        [{gear_idx, _}] <- Regex.scan(~r/\*/, curr, return: :index),
        matches =
          scan_index_with_binary(@r_digits, pre)
          |> Enum.concat(scan_index_with_binary(@r_digits, post))
          |> Enum.concat(scan_index_with_binary(@r_digits, curr)),
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
end
