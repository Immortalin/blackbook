defmodule Mix.Tasks.Blackbook.Install do
  use Mix.Task

  def run(args) do
    IO.puts "Installing Blackbook membership DB"
    System.cmd "mix", ["ecto.migrate"]
    IO.puts "Done!"
  end

end
