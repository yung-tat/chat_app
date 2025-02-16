defmodule ChatApp.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Query
      alias __MODULE__

      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      @derive {Phoenix.Param, key: :id}
    end
  end
end
