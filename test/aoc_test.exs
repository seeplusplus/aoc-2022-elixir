defmodule Day1Test do
  use ExUnit.Case

  test "solve" do
    {_, content} = File.read("./test/test1.txt")
    IO.puts(Day1_2024.solve(content |> String.split("\n")))
    assert 1 == 1
  end
end
