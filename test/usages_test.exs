defmodule UsagesTest do
  @moduledoc """
    Docs:
    gitee: https://gitee.com/lizhaochao/exhmac
    github: https://github.com/lizhaochao/exhmac
  """
  use ExUnit.Case

  test "via functions - ok" do
    assert :ok == Client.A.request_sign_in()
  end

  test "via decorator - ok" do
    assert :ok == Client.B.request_sign_in()
  end

  test "via defhmac - ok" do
    assert :ok == Client.C.request_sign_in()
  end
end
