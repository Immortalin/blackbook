defmodule Blackbook do
  use Application

  def start do
    import Supervisor.Spec
    tree = [worker(Blackbook.Repo, [])]
    opts = [name: Blackbook.Sup, strategy: :one_for_one]
    Supervisor.start_link(tree, opts)
  end

end
