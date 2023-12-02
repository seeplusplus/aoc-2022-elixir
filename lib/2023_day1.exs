defmodule Day1 do
  @numbers [
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine"
  ]

  def read_calibration_values(s) do
    IO.puts(s)
    [scan_left_for_number(s), scan_right_for_number(s)]
  end

  def if_nil_cont(u) do
    case u do
      nil -> {:cont, nil}
      o -> {:halt, o}
    end
  end

  def index_of(haystack, needle) do
    len = String.length(haystack)

    haystack
    |> String.split(needle)
    |> Enum.at(0)
    |> then(fn x ->
      case x do
        len -> :error
        n -> n
      end
    end)
  end

  def search_number_word(s) do
    @numbers
    |> Enum.with_index()
    |> Stream.transform(
      [],
      fn {number, index}, acc ->
        case index_of(s, number) do
          :error -> acc
          n -> [{index + 1, n} | acc]
        end
      end
    )
    |> Enum.sort_by(&(&1 |> elem(1)))
    |> Enum.at(0)
  end

  def find_number(s) do
    s
    |> String.last()
    |> Integer.parse()
    |> then(fn u ->
      case u do
        :error -> search_number_word(s)
        {i, _} -> i
      end
    end)
  end

  def scan_left_for_number(s) do
    len = String.length(s)

    0..len
    |> Enum.reduce_while(
      0,
      &(find_number(s |> String.slice(0..&1)) |> if_nil_cont())
    )
    |> Enum.reduce(
      0,
      &(&1 + &2)
    )
  end

  defp scan_right_for_number(s) do
    len = String.length(s)

    0..(len - 1)
    |> Enum.reduce_while(
      0,
      &(find_number(s |> String.slice((-1 - &1)..-1)) |> if_nil_cont())
    )
    |> Enum.reduce(
      0,
      &(&1 + &2)
    )
  end
end

for line <- IO.stream(), reduce: 0 do
  acc ->
    line |> IO.puts()
    [first, last] = line |> Day1.read_calibration_values()
    acc + (first * 10 + last)
end
|> IO.puts()
