defmodule Mix.Tasks.BlackBook.Install do
  use Mix.Task

  def run(args) do
    IO.puts "Installing BlackBook membership DB"
    System.cmd "mix", ["ecto.migrate"]
    IO.puts "Done!"
  end

end
