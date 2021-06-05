defmodule Client.Hmac do
  @moduledoc """
    Docs:
    gitee: https://gitee.com/lizhaochao/exhmac
    github: https://github.com/lizhaochao/exhmac
  """
  use ExHmac,
    precision: :millisecond,
    hash_alg: :sha512,
    warn: false,
    nonce_len: 20,
    signature_name: :signature,
    access_key_name: :access_key,
    secret_key_name: :secret_key,
    timestamp_name: :timestamp,
    nonce_name: :nonce

  ### Callbacks
  def encode_hash_result(hash_result), do: Base.encode64(hash_result, case: :upper)
end

defmodule Client do
  import Client.Hmac

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
      signature <- sign(params, @access_key, @secret_key)
    ) do
      Server.sign_in(username, password, access_key, timestamp, nonce, signature)
      |> case do
        resp when length(resp) == 7 -> check_hmac(resp, @access_key, @secret_key)
        resp -> resp
      end
    end
  end

  def request_login_in do
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
      signature <- sign(params, @access_key, @secret_key)
    ) do
      Server.login_in(username, password, access_key, timestamp, nonce, signature)
      |> case do
        resp when length(resp) == 7 -> check_hmac(resp, @access_key, @secret_key)
        resp -> resp
      end
    end
  end
end

### ### ###     Above Client        ### ### ### ### ###
### ### ### ### ### ### ### ### ### ### ### ### ### ###
### ### ###     Following Server    ### ### ### ### ###

defmodule Server.Hmac do
  use ExHmac

  use ExHmac.Defhmac,
    precision: :millisecond,
    hash_alg: :sha512,
    warn: false,
    nonce_len: 20,
    signature_name: :signature,
    access_key_name: :access_key,
    secret_key_name: :secret_key,
    timestamp_name: :timestamp,
    nonce_name: :nonce

  ### Callbacks
  def get_secret_key(access_key), do: Helper.get_test_secret_key(access_key)

  def check_nonce(nonce, curr_ts, nonce_freezing_secs, precision) do
    # clean unused warnings
    {nonce, curr_ts, nonce_freezing_secs, precision}
    :ok
  end

  def encode_hash_result(hash_result), do: Base.encode64(hash_result, case: :upper)

  def fmt_resp(resp) do
    case resp do
      [username, password] -> %{a: username, b: password, c: "c", d: "d"}
      err when is_atom(err) -> %{result: 10_001, error_msg: to_string(err)}
      resp -> resp
    end
  end
end

defmodule Server do
  ### Use Decorator by use
  use Server.Hmac
  @decorate check_hmac()
  def sign_in(username, password, access_key, timestamp, nonce, signature) do
    # just clean unused warnings
    {access_key, timestamp, nonce, signature}
    # result
    [username, password]
  end

  ### Use defhmac macro by import
  import Server.Hmac

  defhmac login_in(username, password, access_key, timestamp, nonce, signature) do
    # just clean unused warnings
    {access_key, timestamp, nonce, signature}
    # result
    [username, password]
  end
end
