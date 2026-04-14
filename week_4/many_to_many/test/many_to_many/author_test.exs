defmodule ManyToMany.AuthorTest do
  use ManyToMany.DataCase, async: true

  alias ManyToMany.Author
  alias ManyToMany.Repo

  describe "deletion" do
    test "cascade deletes associated join table records when author is deleted" do
      # Создаём автора
      author =
        %Author{name: "J.R.R. Tolkien"}
        |> Repo.insert!()

      book1 = %ManyToMany.Book{title: "The Hobbit"} |> Repo.insert!()
      book2 = %ManyToMany.Book{title: "The Lord of the Rings"} |> Repo.insert!()

      author
      |> Repo.preload(:books)
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_change(:books, [book1, book2])
      |> Repo.update!()

      assert Repo.aggregate("authors_books", :count, :author_id, where: [author_id: author.id]) == 2

      Repo.delete!(author)

      assert Repo.aggregate("authors_books", :count, :author_id, where: [author_id: author.id]) == 0
      refute Repo.get(ManyToMany.Author, author.id)
    end
  end
end
