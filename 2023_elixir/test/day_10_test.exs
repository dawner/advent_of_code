defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  test "solve/2 part 1" do
    assert Day10.solve(:part_1, "#{File.cwd!()}/test/files/day_10_test_input.txt") == 4
  end

  test "solve/2 part 1 second test" do
    assert Day10.solve(:part_1, "#{File.cwd!()}/test/files/day_10_test_2_input.txt") == 8
  end

  # test "solve/2 part 2" do
  #   assert Day10.solve(:part_2, "#{File.cwd!()}/test/files/day_10_test_input.txt") == 2
  # end
end
