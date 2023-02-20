defmodule Pi do
  def dart(radius) do
    x = Enum.random(0..radius)
    y = Enum.random(0..radius)
    :math.pow(radius, 2) > :math.pow(x, 2) + :math.pow(y, 2)
  end

  def round(0, _, hits) do hits end
  def round(n, radius, hits) do
    if dart(radius) do
      round(n-1, radius, hits+1)
    else
      round(n-1, radius, hits)
    end
  end

  def rounds(rounds, darts, radius) do
    rounds(rounds, darts, 0, radius, 0)
  end
  def rounds(0, _, total, _, hits) do 4*hits/total end
  def rounds(rounds, darts, total, radius, hits) do
    hits = round(darts, radius, hits)
    total = total + darts
    pi = 4*hits/total
    :io.format("Pi: ~.6f - Diff: ~.6f\n", [pi, (pi - :math.pi())])
    rounds(rounds-1, darts, total, radius, hits)
  end
end
