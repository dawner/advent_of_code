defmodule Day23Test do
  use ExUnit.Case
  doctest Day23

  @filename "#{File.cwd!()}/test/files/day_23_test_input.txt"

  test "solve/2 part 1" do
    assert Day23.solve(:part_1, @filename) == 94
  end

  test "solve/2 part 2" do
    assert Day23.solve(:part_2, @filename) == 154
  end
end
