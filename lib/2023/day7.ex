defmodule Mix.Tasks.Day7 do
  use Mix.Task
  def run(_) do
    IO.stream() |> solve() |> IO.puts()
  end
  @card_ordering_1 [?A, ?K, ?Q, ?J, ?T, ?9,  ?8,  ?7, ?6,  ?5,  ?4,  ?3,  ?2]
  @card_ordering_2 [?A, ?K, ?Q, ?T, ?9,  ?8,  ?7, ?6,  ?5,  ?4,  ?3,  ?2, ?J]
  @cards ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2"]

  def sort_by_hand_ascending(h1, h2, part) do
    # case Cards.is_stronger_by_hand_type(h1, h2) do
    #   :win -> false
    #   :loss -> true
    #   :draw -> Cards.is_stronger_by_card_type(h2, h1) === :win
    # end
    h1t = hand_type(h1, part)
    h2t = hand_type(h2, part)

    cond do
      h1t > h2t -> false
      h1t < h2t -> true
      h2t === h1t -> compare_hands_by_card_type(h2, h1, part) === :win
    end
  end

  defp get_card_index(c, ordering) do
    Enum.find_index(ordering, &(&1 === c))
  end

  defp compare_cards(c1, c2, part) do
    ordering = if part === :part1, do: @card_ordering_1, else: @card_ordering_2 
    c1_idx = get_card_index(c1, ordering)
    c2_idx = get_card_index(c2, ordering)

    cond do
      c1_idx < c2_idx -> :win
      c2_idx < c1_idx -> :loss
      true -> :draw
    end
  end

  defp compare_hands_by_card_type(<<c1::8>> <> rest1, <<c2::8>> <> rest2, part) do
    case compare_cards(c1, c2, part) do
      :draw -> compare_hands_by_card_type(rest1, rest2, part)
      other -> other
    end
  end
  
  defp generate_all_hands(h1) do
    cond do
      h1 |> String.contains?("J") -> for card <- @cards,

      new_card <- generate_all_hands(h1 |> String.replace("J", card, global: false)) do
        new_card
      end
      true -> [h1]
    end
  end

  defp brute_force_best_hand(h1) do
    best = generate_all_hands(h1)
      |> Enum.sort(fn cand1, cand2 ->

        hand_type(cand1, :part2) > hand_type(cand2, :part2)
      end)
      |> Enum.at(0)
      best |> hand_type(:part2)
  end

  defp hand_type(h1, part) do
    cache = Process.get(:cache_key, %{})
    store_and_return = fn i ->
      if part === :part2 do
        Process.put(:cache_key, cache |> Map.put(h1, i))
      end
      i
    end
    if part === :part2 and cache |> Map.has_key?(h1) do 
      Map.get(cache, h1)
    else
      values = h1 |> String.graphemes() |> Enum.frequencies() |> Map.values()
      cond do
        part === :part2 and h1 |> String.contains?("J") -> store_and_return.(brute_force_best_hand(h1))
        # five of kind
        values |> Enum.any?(&(&1 === 5)) -> store_and_return.(7)
        # four of kind
        values |> Enum.any?(&(&1 === 4)) -> store_and_return.(6)
        # full house
        values |> Enum.any?(&(&1 === 3)) &&
        values |> Enum.any?(&(&1 === 2)) -> store_and_return.(5)
        # three
        values |> Enum.any?(&(&1 === 3)) -> store_and_return.(4)
        # two pair
        values |> Enum.filter(&(&1 === 2)) |> Enum.count() === 2 -> store_and_return.(3)
        # one
        values |> Enum.filter(&(&1 === 2)) |> Enum.count() === 1 -> store_and_return.(2)
        # high card
        values |> Enum.all?(&(&1 === 1)) -> store_and_return.(1)
      end
    end
  end

  def solve(input) do
    part = :part2
    Process.delete(:key_cache)
    input
      |> Stream.reject(&(&1 === ""))
      |> Stream.map(fn line -> 
          line |> String.trim() |> String.split(" ") |> List.to_tuple()
        end)
      |> Enum.sort(fn {h1, _}, {h2, _} -> sort_by_hand_ascending(h1, h2, part) end)
      |> Stream.with_index()
      |> Enum.reduce(
        0,
        fn {{_, bid}, i}, acc ->
          bid = String.to_integer(bid)
          acc + bid * (i+1)
        end
      )
  end
end
