ExUnit.start()
Blackbook.start()
Mix.Task.run "ecto.migrate", ["--quiet"]
#System.cmd "mix ecto.migrate"
