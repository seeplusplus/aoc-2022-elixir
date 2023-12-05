defmodule Day5Tests do
  use ExUnit.Case

  test "parse seeds correctly" do
    assert Mix.Tasks.Day5.parse_line("seeds: 79 14 55 13") == {:seeds, [79, 14, 55, 13]}
  end
  
  test "parse map line def" do
    assert Mix.Tasks.Day5.parse_line("seed-to-soil map:") == {:map_key, { :seed, :soil }}
  end

  test "parse map line fails" do
    assert Mix.Tasks.Day5.parse_line("50 98 2") == {:range, {50..51, 98..99}}
  end

  test "range util does not lie" do
    assert (RangeUtil.from_start(120, 300) |> Enum.count()) === 300 
  end

  test "range util transpose does not lie" do
    assert RangeUtil.transpose(98, 98..99, 50..51) === 50
  end

  test "parse works" do
    ex = ~s"seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48"
    assert Mix.Tasks.Day5.parse(ex |> String.split("\n")) == %{
      :seeds => [79, 14, 55, 13], 
      :maps => %{:seed => {:soil, [{52..99, 50..97}, {50..51, 98..99}]}},
      :last_map_key => :seed
    }
  end

  test "parse doesn't crash with whole input" do
    ex = ~s"seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15


fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4


water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13


temperature-to-humidity map:

0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"
  assert ex |> String.split("\n") |> Mix.Tasks.Day5.parse() |> Mix.Tasks.Day5.part1() == 35
  end
end
