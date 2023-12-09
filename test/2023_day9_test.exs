defmodule Day9Tests do
  use ExUnit.Case

  @puzzle_input ~s"0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45"

  assert "gets part 2 example input correct" do
    assert Mix.Tasks.Day9.solve(@puzzle_input, :part2) === 2
  end

  assert "gets part 1 example input correct" do
    assert Mix.Tasks.Day9.solve(@puzzle_input, :part1) === 114
  end
end
