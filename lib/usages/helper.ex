defmodule Helper do
  @moduledoc """
    Docs:
    gitee: https://gitee.com/lizhaochao/exhmac
    github: https://github.com/lizhaochao/exhmac
  """

  def get_error_code, do: -1

  def get_test_access_key, do: "test_key"
  def get_test_secret_key(_key \\ nil), do: "test_secret"

  def append_signature(params, signature), do: Enum.concat(params, signature: signature)

  def serialize({:ok, json_string}), do: json_string
  def serialize(params), do: params |> Map.new() |> Poison.encode() |> serialize()

  def deserialize({:ok, map}), do: map
  def deserialize(json_string), do: json_string |> Poison.decode() |> deserialize()

  def to_json_string(term), do: Poison.encode(term)

  @doc """
  You can write gc metadata to log via lager.
  """
  def gc_log_call_back(meta), do: IO.inspect({"gc stat:", meta})
end
