defmodule Day15 do
  def part1(y) do
    sensors = Stream.map(input(), fn(row) -> parse(row) end)
    row = Row.new()
    row = Enum.reduce(sensors, row, fn({:sensor, sensor, beacon}, row) ->
      block(sensor, beacon, y, row)
    end)
    Row.blocked(row)
  end

  def block({sx, sy}, {bx, by}, y, row) do
    dist = abs(sx - bx) +  abs(sy - by)
    diff = dist - abs(sy - y)
    Row.block(row, (sx-diff), (sx+diff))
  end

  def input() do
    File.stream!("advent/day15/input.txt")
  end

  def sample() do
    ["Sensor at x=2, y=18: closest beacon is at x=-2, y=15",
     "Sensor at x=9, y=16: closest beacon is at x=10, y=16",
     "Sensor at x=13, y=2: closest beacon is at x=15, y=3",
     "Sensor at x=12, y=14: closest beacon is at x=10, y=16",
     "Sensor at x=10, y=20: closest beacon is at x=10, y=16",
     "Sensor at x=14, y=17: closest beacon is at x=10, y=16",
     "Sensor at x=8, y=7: closest beacon is at x=2, y=10",
     "Sensor at x=2, y=0: closest beacon is at x=2, y=10",
     "Sensor at x=0, y=11: closest beacon is at x=2, y=10",
     "Sensor at x=20, y=14: closest beacon is at x=25, y=17",
     "Sensor at x=17, y=20: closest beacon is at x=21, y=22",
     "Sensor at x=16, y=7: closest beacon is at x=15, y=3",
     "Sensor at x=14, y=3: closest beacon is at x=15, y=3",
     "Sensor at x=20, y=1: closest beacon is at x=15, y=3"]
  end

  def parse(input) do
    [_, sx, sy, _, bx, by] = String.split(input, [":","="])
    {sx, _} = Integer.parse(sx)
    {sy, _} = Integer.parse(sy)
    {bx, _} = Integer.parse(bx)
    {by, _} = Integer.parse(by)
    {:sensor, {sx, sy}, {bx, by}}
  end
end
