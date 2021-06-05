defmodule Client.A do
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
      params <- make_req_params(),
      signature <- Helper.make_signature(params, @access_key, @secret_key),
      params <- Helper.append_signature(params, signature),
      json_string <- Helper.serialize(params)
    ) do
      json_string
      |> Server.A.sign_in()
      |> Helper.deserialize()
      |> check_hmac(@access_key, @secret_key)
    end
  end

  def make_req_params(timestamp \\ nil, nonce \\ nil) do
    with {:ok, nested} <- Helper.to_json_string(%{id_number: "460200", mobile: "10000000000"}),
         params <- [
           access_key: @access_key,
           username: "ljy",
           password: "lijiayou",
           nested: nested,
           timestamp: timestamp || gen_timestamp(),
           nonce: nonce || gen_nonce()
         ] do
      params
    end
  end
end

### ### ###     Above Client        ### ### ### ### ###
### ### ### ### ### ### ### ### ### ### ### ### ### ###
### ### ###     Following Server    ### ### ### ### ###

defmodule Server.A do
  use ExHmac

  def sign_in(json_string) do
    params = Helper.deserialize(json_string)
    access_key = get_key(params)
    secret_key = get_secret(access_key)

    error_code =
      params
      |> check_hmac(access_key, secret_key)
      |> case do
        :ok -> 0
        _ -> -1
      end

    make_resp_with_hmac(error_code, access_key, secret_key)
  end

  def get_key(%{"access_key" => access_key}), do: access_key
  def get_secret(key), do: Helper.get_test_secret_key(key)

  def make_resp_with_hmac(code, access_key, secret_key) do
    with(
      params <- make_res_params(code),
      signature <- Helper.make_signature(params, access_key, secret_key),
      params <- Helper.append_signature(params, signature),
      resp <- Helper.serialize(params)
    ) do
      resp
    end
  end

  def make_res_params(code) do
    [
      result: code,
      timestamp: gen_timestamp(),
      nonce: gen_nonce()
    ]
  end
end
