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

  describe "customize hmac" do
    test "decorator - no config" do
      {:post_hook, resp} = Client.request_sign_in()
      %{error_msg: error_msg} = Map.new(resp)
      assert "signature_error" == error_msg
    end

    test "defhmac - config many" do
      assert :ok == Client.request_login_in()
    end
  end
end
