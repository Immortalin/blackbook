defmodule Blackbook.Queries do

  import Ecto.Query
  alias Blackbook.Repo

  def get_login(params) do
    Repo.get_by(Blackbook.Login, params)
  end
  
  def get_user(params) do
    Repo.get_by(Blackbook.User, params)
  end

end
