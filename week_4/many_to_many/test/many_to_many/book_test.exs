defmodule ManyToMany.BookTest do
  use ManyToMany.DataCase, async: true

  alias ManyToMany.Book
  alias ManyToMany.Repo


  describe "deletion" do
    test "cascade deletes associated join table records when book is deleted" do
      book = %Book{title: "The Hobbit"} |> Repo.insert!()

      author1 = %ManyToMany.Author{name: "J.R.R. Tolkien"} |> Repo.insert!()
      author2 = %ManyToMany.Author{name: "Other J.R.R. Tolkien"} |> Repo.insert!()

      book
      |> Repo.preload(:authors)
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_change(:authors, [author1, author2])
      |> Repo.update!()

      assert Repo.aggregate("authors_books", :count, :book_id, where: [book_id: book.id]) == 2

      Repo.delete!(book)

      assert Repo.aggregate("authors_books", :count, :book_id, where: [book_id: book.id]) == 0
      refute Repo.get(ManyToMany.Book, book.id)
    end
  end
end
