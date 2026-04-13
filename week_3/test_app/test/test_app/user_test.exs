defmodule TestApp.UserTest do
  use TestApp.DataCase, async: true

  alias TestApp.User

  describe "changeset/2" do
    @valid_attrs %{name: "John Doe", email: "john@example.com"}
    @invalid_attrs %{name: nil, email: nil}

    test "with valid attributes" do
      changeset = User.changeset(%User{}, @valid_attrs)

      assert changeset.valid? == true
      assert get_field(changeset, :name) == "John Doe"
      assert get_field(changeset, :email) == "john@example.com"
    end

    test "with missing name" do
      attrs = %{@valid_attrs | name: nil}
      changeset = User.changeset(%User{}, attrs)

      assert changeset.valid? == false
      assert errors_on(changeset)[:name] == ["can't be blank"]
    end

    test "with missing email" do
      attrs = %{@valid_attrs | email: nil}
      changeset = User.changeset(%User{}, attrs)

      assert changeset.valid? == false
      assert errors_on(changeset)[:email] == ["can't be blank"]
    end

    test "with both name and email missing" do
      changeset = User.changeset(%User{}, @invalid_attrs)

      assert changeset.valid? == false
      assert errors_on(changeset)[:name] == ["can't be blank"]
      assert errors_on(changeset)[:email] == ["can't be blank"]
    end

    test "with empty strings" do
      attrs = %{name: "", email: ""}
      changeset = User.changeset(%User{}, attrs)

      assert changeset.valid? == false
      assert errors_on(changeset)[:name] == ["can't be blank"]
      assert errors_on(changeset)[:email] == ["can't be blank"]
    end
  end
end
