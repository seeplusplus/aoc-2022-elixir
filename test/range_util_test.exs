defmodule RangeUtilTest do
  use ExUnit.Case

  test "RangeUtil.difference should work with disjoint ranges" do
    assert RangeUtil.difference(1..10, 11..20) == [1..10]
  end

  test "RangeUtil.difference should work with contained ranges" do
    assert RangeUtil.difference(1..10, 2..5) == [1..1, 6..10]
    assert RangeUtil.difference(1..10, 1..10) == []
    assert RangeUtil.difference(1..10, 2..10) == [1..1]
    assert RangeUtil.difference(1..10, -1..11) == []
    assert RangeUtil.difference(1..10, 1..12) == []
    assert RangeUtil.difference(1..10, 2..2) == [1..1, 3..10]
  end

  test "RangeUtil.difference should work with partially overlapped ranges" do
    assert RangeUtil.difference(1..10, -1..3) == [4..10]
    assert RangeUtil.difference(1..10, 1..1) == [2..10]
    assert RangeUtil.difference(1..10, 8..12) == [1..7]
    assert RangeUtil.difference(1..10, 2..12) == [1..1]
  end

  test "RangeUtil.intersection should work with contained ranges" do
    assert RangeUtil.intersection(1..10, 1..3) == 1..3
    assert RangeUtil.intersection(1..10, -1..3) == 1..3
    assert RangeUtil.intersection(-1..10, 1..3) == 1..3
    assert RangeUtil.intersection(-1..10, -100..300) == -1..10
    assert RangeUtil.intersection(-1..10, 11..300) == (..)
  end
end
