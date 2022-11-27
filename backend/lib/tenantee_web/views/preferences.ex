defmodule TenanteeWeb.PreferencesView do
  def render("show.json", %{preferences: preferences}) do
    %{preferences: Enum.map(preferences, &render("show.json", %{preference: &1}))}
  end

  def render("show.json", %{preference: preference}) do
    %{
      name: preference.name,
      value: preference.value
    }
  end
end
