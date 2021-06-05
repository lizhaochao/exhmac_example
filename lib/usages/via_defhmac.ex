defmodule Client.C do
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
      Server.C.sign_in(username, password, access_key, timestamp, nonce, signature)
      |> check_hmac(@access_key, @secret_key)
    end
  end
end

### ### ###     Above Client        ### ### ### ### ###
### ### ### ### ### ### ### ### ### ### ### ### ### ###

### ### ### ### ### ### ### ### ### ### ### ### ### ###
### ### ###     Following Server    ### ### ### ### ###

defmodule Server.C.Hmac do
  use ExHmac.Defhmac

  def get_secret_key(access_key) do
    Helper.get_test_secret_key(access_key)
  end
end

defmodule Server.C do
  import Server.C.Hmac

  defhmac sign_in(username, password, access_key, timestamp, nonce, signature) do
    {access_key, timestamp, nonce, signature}
    [username, password]
  end
end
