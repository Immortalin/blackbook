defmodule BlackBook do
  use Application

  def start do
    import Supervisor.Spec
    tree = [worker(BlackBook.Repo, [])]
    opts = [name: BlackBook.Sup, strategy: :one_for_one]
    Supervisor.start_link(tree, opts)
  end

end
