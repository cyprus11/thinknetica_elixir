defmodule ManyToMany.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    many_to_many :authors, ManyToMany.Author, join_through: "authors_books"

    timestamps()
  end

  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
