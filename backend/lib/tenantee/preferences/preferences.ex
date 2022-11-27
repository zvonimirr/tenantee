defmodule Tenantee.Preferences do
  @moduledoc """
  This module contains all the necessary functions to manage the preferences.
  """
  alias Tenantee.Repo
  alias Tenantee.Preferences.Schema

  def get_preferences do
    Repo.all(Schema)
  end
end
