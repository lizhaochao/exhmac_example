defmodule Helper do
  use ExHmac

  def get_error_code, do: -1

  def get_test_access_key, do: "test_key"
  def get_test_secret_key(_key \\ nil), do: "test_secret"

  def make_signature(params, access_key, secret_key), do: sign(params, access_key, secret_key)
  def append_signature(params, signature), do: Enum.concat(params, signature: signature)

  def serialize({:ok, json_string}), do: json_string
  def serialize(params), do: params |> Map.new() |> Poison.encode() |> serialize()

  def deserialize({:ok, map}), do: map
  def deserialize(json_string), do: json_string |> Poison.decode() |> deserialize()

  def to_json_string(term), do: Poison.encode(term)
end
