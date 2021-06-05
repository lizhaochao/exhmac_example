defmodule UsagesTest do
  use ExUnit.Case

  setup do
    ExHmac.Repo.init()
    :ok
  end

  test "via functions - ok" do
    assert :ok == Client.A.request_sign_in()
  end
end
