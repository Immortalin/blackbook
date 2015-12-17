defmodule Blackbook.SetupDBTest do
  use ExUnit.Case
  alias

  defmodule TestingModule.config do
    config :Blackbook, :TestingModule,
    repo: TestingModule.repo


  end

end
