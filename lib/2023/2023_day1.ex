defmodule Day1_2024 do
  def solve(input) do
    input
    |> Enum.filter(&(String.length(&1) > 0))
    |> Enum.reduce(
      0,
      fn line, acc ->
        acc + parse_number(line)
      end
    )
  end

  def parse_number(line) do
    left_number = find_first_number(line)
    right_number = find_first_number_from_right(line)
    left_number * 10 + right_number
  end

  def find_first_number(l) do
    1..(l |> String.length())
    |> Enum.reduce_while(
      0,
      fn i, _ ->
        int_at_pos = l |> String.at(i - 1) |> Integer.parse()

        case int_at_pos do
          :error ->
            l
            |> String.slice(0, i)
            |> search_for_written_number()
            |> then(fn res ->
              case res do
                nil -> {:cont, 0}
                n -> {:halt, n}
              end
            end)

          n ->
            {:halt, n |> elem(0)}
        end
      end
    )
  end

  def find_first_number_from_right(l) do
    len = String.length(l)

    1..len
    |> Enum.reduce_while(
      0,
      fn i, _ ->
        cur_char = l |> String.at(len - i)
        # IO.puts("examining ")
        # IO.puts(cur_char)
        int_at_pos = cur_char |> Integer.parse()

        case int_at_pos do
          :error ->
            l
            |> String.slice(len - i, len)
            |> search_for_written_number()
            |> then(fn res ->
              case res do
                nil -> {:cont, 0}
                n -> {:halt, n}
              end
            end)

          {n, _} ->
            {:halt, n}
        end
      end
    )
  end

  def search_for_written_number(line) do
    # IO.puts("searching " <> line)

    numbers = [
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

    numbers_map = %{
      "one" => 1,
      "two" => 2,
      "three" => 3,
      "four" => 4,
      "five" => 5,
      "six" => 6,
      "seven" => 7,
      "eight" => 8,
      "nine" => 9
    }

    if String.length(line) < 3 do
      nil
    else
      splits =
        numbers
        |> Enum.map(fn number ->
          split = String.split(line, number)
          {number, split |> Enum.map(&(&1 |> String.length()))}
        end)
        |> Enum.filter(&(&1 |> elem(1) |> Enum.count() > 1))

      # IO.puts(inspect(splits))

      number_word =
        splits
        |> Enum.sort_by(fn split ->
          split |> elem(1) |> List.first()
        end)
        |> Enum.at(0)

      res =
        if is_tuple(number_word) do
          Map.get(numbers_map, number_word |> elem(0))
        else
          nil
        end

      res
    end
  end
end
