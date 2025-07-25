defmodule AiPersonalChefTest do
  use ExUnit.Case
  doctest AiPersonalChef

  test "greets the world" do
    assert AiPersonalChef.hello() == :world
  end
end
