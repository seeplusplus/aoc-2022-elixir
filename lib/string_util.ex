defmodule StringUtil do
  def transpose(str) do
    EnumUtil.transpose(
      str
        |> String.split("\n")
        |> Enum.map(&String.graphemes(&1))

    )|> Enum.map(&Enum.join(&1,"")) |> Enum.join("\n")
  end
end
