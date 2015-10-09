defmodule Mix.Tasks.Blackbook.Remove do
  use Mix.Task

  def run(args) do
    IO.puts "Removing Blackbook membership DB"
    System.cmd "mix", ["ecto.rollback", "--all", "--repo", "Blackbook.Repo"]
    IO.puts "Done!"
  end

end
