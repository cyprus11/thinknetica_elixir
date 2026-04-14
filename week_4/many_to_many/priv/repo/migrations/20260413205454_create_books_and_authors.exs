defmodule ManyToMany.Repo.Migrations.CreateBooksAndAuthors do
  use Ecto.Migration

  def change do
    create table("authors") do
      add :name, :string
      timestamps()
    end

    create table("books") do
      add :title, :string
      timestamps()
    end

    create table("authors_books", primary_key: false) do
      add :author_id, references(:authors, on_delete: :delete_all), null: false
      add :book_id, references(:books, on_delete: :delete_all), null: false
    end

    create unique_index(:authors_books, [:author_id, :book_id])
  end
end
