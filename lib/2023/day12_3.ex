defmodule SpringParse do
  defp enum_repeat(enum, n) do
    for _ <- 1..n do
      enum
    end
    |> Enum.flat_map(& &1)
  end

  def into_spring_count(str \\ ".........#####") do
    str
    |> String.split(".")
    |> Stream.reject(&(&1 == ""))
    |> Enum.map(&String.length(&1))
  end

  def generate(s \\ "????....?#####") do
    chars = s |> String.graphemes()

    q_map =
      for {{i, _}, j} <-
            (for {q, i} <- chars |> Stream.with_index(), q == "?" do
               {i, q}
             end)
            |> Stream.with_index(),
          into: %{} do
        {i, j}
      end

    possibilities = chars |> Stream.filter(&(&1 == "?")) |> Enum.count()

    for p <- 0..(2 ** possibilities - 1) do
      for {l, i} <- chars |> Stream.with_index() do
        if l == "?" do
          case Bitwise.band(2 ** Map.get(q_map, i), p) do
            0 -> "."
            n when n > 0 -> "#"
          end
        else
          l
        end
      end
    end
    |> Stream.map(&Enum.join(&1, ""))
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Stream.reject(&(&1 === ""))
    |> Stream.map(fn line ->
      [pattern, exp] = line |> String.split(" ")
      exp = String.split(exp, ",") |> Enum.map(&String.to_integer/1)
      [pattern, exp]
    end)
  end

  def parse_2(input) do
    input
    |> String.split("\n")
    |> Stream.reject(&(&1 == ""))
    |> Stream.map(fn line ->
      [pattern, exp] = line |> String.split(" ")
      pattern = enum_repeat([pattern], 5) |> Enum.join("?")
      exp = String.split(exp, ",") |> Stream.map(&String.to_integer/1) |> enum_repeat(5)

      [pattern, exp]
    end)
  end

  def count_solutions(pattern, expectation) do
    matches =
      SpringParse.generate(pattern)
      |> Stream.map(&{&1, SpringParse.into_spring_count(&1)})
      |> Stream.filter(&(&1 |> elem(1) == expectation))

    Enum.count(matches)
  end

  def solve(input) do
    for [pattern, expectation] <- parse(input),
        reduce: 0 do
      acc ->
        acc + count_solutions(pattern, expectation)
    end
  end
end
