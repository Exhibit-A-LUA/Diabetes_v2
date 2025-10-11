defmodule DiabetesV2Web.ParamHelpers do
  @moduledoc """
  Normalizes incoming form parameters from LiveView forms
  before sending them to Ash changesets.

  - Converts empty strings to `nil`
  - Converts numeric strings to integers or floats
  - Converts boolean-like strings to booleans
  - Recursively normalizes maps and lists
  """

  @doc """
  Main entry point: normalize any map, list, or value from form params.
  """
  def normalize_form_params(params) when is_map(params) do
    Enum.reduce(params, %{}, fn {key, value}, acc ->
      Map.put(acc, key, normalize_value(value))
    end)
  end

  def normalize_form_params(value), do: normalize_value(value)

  # --- Core normalizer ---

  # 1. Empty strings → nil
  defp normalize_value(""), do: nil

  # 2. Recursively normalize nested maps
  defp normalize_value(value) when is_map(value), do: normalize_form_params(value)

  # 3. Recursively normalize lists
  defp normalize_value(value) when is_list(value), do: Enum.map(value, &normalize_value/1)

  # 4. Convert numeric and boolean strings
  defp normalize_value(value) when is_binary(value) do
    cond do
      String.match?(value, ~r/^-?\d+$/) -> String.to_integer(value)
      String.match?(value, ~r/^-?\d+\.\d+$/) -> String.to_float(value)
      value in ["true", "on", "yes"] -> true
      value in ["false", "off", "no"] -> false
      true -> value
    end
  end

  # 5. Everything else (integers, floats, atoms, booleans) → leave as-is
  defp normalize_value(value), do: value
end
