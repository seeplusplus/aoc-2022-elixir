defmodule Card do
  defp split(str) do
    str
    |> String.trim()
    |> String.split(" ")
    |> Enum.filter(fn s -> String.length(s) !== 0 end)
  end

  defp count_winning_cards(player_card, winning_numbers) do
    player_card |> Enum.filter(fn n -> Enum.any?(winning_numbers, &(&1 == n)) end) |> Enum.count()
  end

  defp parse_card("Card " <> rest) do
    [_, numbers] = rest |> String.split(":")
    [winning, player] = numbers |> String.split("|")

    [winning |> split(), player |> split()]
  end

  def parse(input) do
    for card <- input |> String.split("\n"),
      card != "",
      [winning_numbers, our_numbers] = parse_card(card) do
      [winning_numbers, our_numbers]
    end
  end

  def part1(cards) do
    for [winning_numbers, our_numbers] <- cards do
      case count_winning_cards(our_numbers, winning_numbers) do
        n when n > 0 -> 2 ** (n - 1)
        0 -> 0
      end
    end
    |> Enum.sum()
  end

  def part2(cards) do
    cards
    |> Enum.with_index()
    |> Enum.reduce(
      List.duplicate(1, cards |> Enum.count()),
      fn {[winning, player], idx}, copies ->
        self_copies = Enum.at(copies, idx)
        won = count_winning_cards(player, winning)
        slice = if won > 0, do: (idx + 1)..(idx + won), else: (..)

        copies
        |> Enum.with_index()
        |> Enum.map(fn {count, idx} ->
          if idx in slice, do: count + self_copies, else: count
        end)
      end
    )
    |> Enum.sum()
  end
end
