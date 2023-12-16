defmodule TupleUtil do
  def pairwise_sum(t1, t2) do
    Tuple.to_list(t1)
    |> Stream.zip(Tuple.to_list(t2))
    |> Stream.map(&(elem(&1, 0) + elem(&1, 1)))
    |> Enum.reduce({}, &Tuple.append(&2, &1))
  end
end
