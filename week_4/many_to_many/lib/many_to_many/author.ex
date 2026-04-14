defmodule ManyToMany.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors" do
    field :name, :string
    many_to_many :books, ManyToMany.Book, join_through: "authors_books"

    timestamps()
  end

  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
