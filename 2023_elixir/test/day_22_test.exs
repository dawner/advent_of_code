defmodule Day22Test do
  use ExUnit.Case
  doctest Day22

  @filename "#{File.cwd!()}/test/files/day_22_test_input.txt"

  test "solve/2 part 1" do
    assert Day22.solve(:part_1, @filename) == 5
  end

  test "solve/2 part 2 - 5000 steps" do
    assert Day22.solve(:part_2, @filename) == 7
  end
end
