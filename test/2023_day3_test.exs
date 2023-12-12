defmodule Day3Test do
  use ExUnit.Case

  test "part 1 should solve example input" do
    {_, content} = File.read("./test/2023_day3_example.txt")
    content = content |> String.split("\n")
    assert Mix.Tasks.Day3.part1(content) == 4361
  end

  test "part 2 should solve example input" do
    {_, content} = File.read("./test/2023_day3_example.txt")
    content = content |> String.split("\n")
    assert Mix.Tasks.Day3.part2(content) == 467_835
  end

end
