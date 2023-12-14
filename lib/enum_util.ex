defmodule EnumUtil do
  def transpose(enum) do
    col_count = enum |> Enum.at(0) |> Enum.count()

    for col <- 0..(col_count - 1) do
      enum |> Enum.map(&Enum.at(&1, col))
    end
  end
end
