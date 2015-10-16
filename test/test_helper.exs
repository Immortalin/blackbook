ExUnit.start()
Blackbook.start()
Mix.Task.run "ecto.migrate", ["--quiet"]
