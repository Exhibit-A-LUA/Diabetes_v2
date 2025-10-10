defmodule DiabetesV2Web.ParamHelpers do
  @moduledoc """
  Cleans up and type-casts incoming form params from LiveView forms
  before sending them to Ash changesets.
  """

  # Main entry point
  def transform_empty_strings(params) when is_map(params) do
    Enum.reduce(params, %{}, fn {key, value}, acc ->
      Map.put(acc, key, normalize_param_value(key, value))
    end)
  end

  def transform_empty_strings(value), do: value

  # --- Core transformers ---

  # 1. Empty strings → nil
  defp normalize_param_value(_key, ""), do: nil

  # 2. Nested maps (recursively clean them)
  defp normalize_param_value(_key, value) when is_map(value),
    do: transform_empty_strings(value)

  # 3. Lists of maps or values
  defp normalize_param_value(_key, value) when is_list(value),
    do: Enum.map(value, &transform_empty_strings/1)

  # 4. Boolean conversions
  defp normalize_param_value(_key, value) when is_binary(value) do
    cond do
      # Numbers first
      String.match?(value, ~r/^-?\d+$/) -> String.to_integer(value)
      String.match?(value, ~r/^-?\d+\.\d+$/) -> String.to_float(value)
      # Booleans after
      value in ["true", "on", "yes"] -> true
      value in ["false", "off", "no"] -> false
      true -> value
    end
  end

  # 5. Leave everything else as-is
  defp normalize_param_value(_key, value), do: value
end
