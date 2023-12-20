defmodule RangeUtil do
  @spec from_start(integer(), integer()) :: Range.t()
  def from_start(start, len) do
    if len == 0 do
      ..
    else
      start..(start + len - 1)
    end
  end

  def transpose(value, source, dest) do
    offset = value - (source |> Enum.at(0))
    (dest |> Enum.at(0)) + offset
  end

  @spec contains?(Range.t(), Range.t()) :: boolean
  def contains?(r1, r2) do
    r2.first >= r1.first and r2.last <= r1.last
  end

  @spec difference(Range.t(), Range.t()) :: [Range.t()]
  def difference(r1, r2) do
    cond do
      Range.disjoint?(r1, r2) ->
        [r1]

      RangeUtil.contains?(r2, r1) ->
        []

      RangeUtil.contains?(r1, r2) ->
        s1_len = r2.first - r1.first
        s2_len = r1.last - r2.last

        [
          RangeUtil.from_start(r1.first, s1_len),
          RangeUtil.from_start(r2.last + 1, s2_len)
        ]
        |> Enum.reject(fn r -> r == .. end)

      r2.first <= r1.first and r2.last <= r1.last ->
        s1_len = r1.last - r2.last
        [RangeUtil.from_start(r2.last + 1, s1_len)]

      r2.first >= r1.first and r2.last >= r1.last ->
        s1_len = r2.first - r1.first
        [RangeUtil.from_start(r1.first, s1_len)]
    end
  end

  @spec intersection(Range.t(), Range.t()) :: Range.t()
  def intersection(r1, r2) do
    cond do
      Range.disjoint?(r1, r2) -> ..
      RangeUtil.contains?(r2, r1) -> r1
      RangeUtil.contains?(r1, r2) -> r2
      r2.first <= r1.first and r2.last <= r1.last -> Range.new(r1.first, r2.last)
      r2.first >= r1.first and r2.last >= r1.last -> Range.new(r2.first, r1.last)
    end
  end

  @spec split_at(range :: Range.t(), value :: integer(), bound :: :lb | :ub) :: [Range.t()]
  def split_at(range, value, bound) do
    if value <= range.first or value >= range.last do
      [range]
    else
      ls = min(range.first, value - 1)
      le = min(range.last, value - 1)
      rs = max(range.first, value + 1)
      re = max(range.last, value + 1)

      if bound == :lb do
        [ls..value, rs..re]
      else
        [ls..le, value..re]
      end
    end
  end
end
