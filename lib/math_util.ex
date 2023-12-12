defmodule MathUtil do
  @spec gcd(integer(), integer()) :: integer()
  def gcd(0, 0) do
    0
  end

  @spec gcd(integer(), integer()) :: integer()
  def gcd(a, a) do
    a
  end

  @spec gcd(integer(), integer()) :: integer()
  def gcd(a, b) when a > b do
    gcd(a - b, b)
  end

  @spec gcd(integer(), integer()) :: integer()
  def gcd(a, b) do
    gcd(a, b - a)
  end

  @spec lcm(integer(), integer()) :: integer()
  def lcm(a, b) do
    div(a * b, gcd(a, b))
  end
end
