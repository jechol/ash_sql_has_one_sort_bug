defmodule MyDomain.PostTest do
  use AiPersonalChef.DataCase

  alias MyDomain.{User, Post, Comment, Tag, PostTag}

  describe "comments" do
    setup do
      author = Ash.Changeset.for_create(User, :create, age: 29) |> Ash.create!()

      post =
        Ash.Changeset.for_create(Post, :create, %{author_id: author.id, date: ~D[2025-01-01]})
        |> Ash.create!()

      [
        {~D[2025-01-03], false},
        {~D[2025-01-02], true},
        {~D[2025-01-05], false},
        {~D[2025-01-04], true},
        {~D[2025-01-01], false}
      ]
      |> Enum.each(fn {date, hidden} ->
        Ash.Changeset.for_create(Comment, :create, post_id: post.id, date: date, hidden: hidden)
        |> Ash.create!()
      end)

      %{post: post}
    end

    test "has_many with sort", %{post: post} do
      assert [
               %{date: ~D[2025-01-05]},
               %{date: ~D[2025-01-04]},
               %{date: ~D[2025-01-03]},
               %{date: ~D[2025-01-02]},
               %{date: ~D[2025-01-01]}
             ] = Ash.load!(post, :comments).comments
    end

    test "has_one with sort", %{post: post} do
      assert %{date: ~D[2025-01-05]} =
               Ash.load!(post, :latest_comment).latest_comment
    end

    test "has_one with filter and sort", %{post: post} do
      assert %{date: ~D[2025-01-04]} =
               Ash.load!(post, :latest_hidden_comment).latest_hidden_comment
    end
  end

  describe "tags" do
    setup do
      author = Ash.Changeset.for_create(User, :create, age: 29) |> Ash.create!()

      post =
        Ash.Changeset.for_create(Post, :create, %{author_id: author.id, date: ~D[2025-01-01]})
        |> Ash.create!()

      [
        %{importance: 6},
        %{importance: 5},
        %{importance: 4},
        %{importance: 3},
        %{importance: 7},
        %{importance: 2},
        %{importance: 1},
        %{importance: 0}
      ]
      |> Enum.each(fn attrs ->
        tag =
          Ash.Changeset.for_create(Tag, :create, attrs)
          |> Ash.create!()

        _post_tag =
          Ash.Changeset.for_create(PostTag, :create, post_id: post.id, tag_id: tag.id)
          |> Ash.create!()
      end)

      %{post: post}
    end

    test "many_to_many with sort", %{post: post} do
      Logger.configure(level: :debug)

      assert [
               %{importance: 7},
               %{importance: 6},
               %{importance: 5},
               %{importance: 4},
               %{importance: 3},
               %{importance: 2},
               %{importance: 1},
               %{importance: 0}
             ] = Ash.load!(post, :tags).tags
    end

    test "has_one with filter and sort", %{post: post} do
      Logger.configure(level: :debug)

      assert %{importance: 7} = Ash.load!(post, :most_important_tag).most_important_tag
    end
  end
end
