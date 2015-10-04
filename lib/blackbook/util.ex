defmodule Blackbook.Util do

  def hash_password({:error, err}) do
    {:error, err}
  end

  def hash_password({:ok, creds}) do
    {email, password, _} = creds
    #reset these if you want stronger password checks
    case Comeonin.create_hash(password, [min_length: 6, extra_chars: false, common: false]) do
      {:ok, hashed} -> {:ok, {email, hashed}}
      {:error, err} -> {:error, err}
    end
  end

  def hash_password(password) do
     Comeonin.create_hash(password, [min_length: 6, extra_chars: false, common: false])
  end

end
