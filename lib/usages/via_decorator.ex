defmodule Client.B do
  @moduledoc """
    Docs:
    gitee: https://gitee.com/lizhaochao/exhmac
    github: https://github.com/lizhaochao/exhmac
  """
  use ExHmac

  @access_key Helper.get_test_access_key()
  @secret_key Helper.get_test_secret_key(@access_key)

  def request_sign_in do
    with(
      username <- "ljy",
      password <- "lijiayou",
      access_key <- @access_key,
      timestamp <- gen_timestamp(),
      nonce <- gen_nonce(),
      params <- [
        username: username,
        password: password,
        access_key: access_key,
        timestamp: timestamp,
        nonce: nonce
      ],
      signature <- Helper.make_signature(params, @access_key, @secret_key)
    ) do
      Server.B.sign_in(username, password, access_key, timestamp, nonce, signature)
      |> check_hmac(@access_key, @secret_key)
    end
  end
end

### ### ###     Above Client        ### ### ### ### ###
### ### ### ### ### ### ### ### ### ### ### ### ### ###
### ### ###     Following Server    ### ### ### ### ###

defmodule Server.B.Hmac do
  use ExHmac

  def get_secret_key(access_key) do
    Helper.get_test_secret_key(access_key)
  end

  def fmt_resp(resp) do
    case resp do
      [username, password] -> %{username: username, passwd: password}
      err when is_atom(err) -> %{result: 10_001, error_msg: to_string(err)}
      resp -> resp
    end
  end
end

defmodule Server.B do
  use Server.B.Hmac

  @decorate check_hmac()
  def sign_in(username, password, access_key, timestamp, nonce, signature) do
    {access_key, timestamp, nonce, signature}
    [username, password]
  end
end
