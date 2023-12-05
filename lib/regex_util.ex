defmodule RegexUtil do
  @spec scan_index_with_binary(Regex.t(), binary()) :: list()
  def scan_index_with_binary(regex, binary) do
    Regex.scan(regex, binary, return: :index)
    |> Enum.map(fn [{index, len}] ->
      {index, len, binary |> String.slice(index, len) |> Integer.parse() |> elem(0)}
    end)
  end
end
