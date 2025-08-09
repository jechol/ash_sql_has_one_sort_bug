defmodule MyDomain.TagTest do
  use AiPersonalChef.DataCase

  alias MyDomain.{Post, Comment, Tag, PostTag, User}

  setup do
    tag = Ash.Changeset.for_create(Tag, :create) |> Ash.create!()

    posts =
      [
        {~D[2025-01-03], 37},
        {~D[2025-01-02], 41},
        {~D[2025-01-05], 39},
        {~D[2025-01-04], 40},
        {~D[2025-01-01], 38}
      ]
      |> Enum.each(fn {date, author_age} ->
        user = Ash.Changeset.for_create(User, :create, age: author_age) |> Ash.create!()

        post =
          Ash.Changeset.for_create(Post, :create, author_id: user.id, date: date) |> Ash.create!()

        Ash.Changeset.for_create(PostTag, :create, post_id: post.id, tag_id: tag.id)
        |> Ash.create!()
      end)

    %{tag: tag, posts: posts}
  end

  test "latest_post (order by attribute)", %{tag: tag, posts: posts} do
    latest_post = Ash.load!(tag, :latest_post).latest_post

    assert latest_post.date == ~D[2025-01-05]
  end

  test "latest_post (order by calculation)", %{tag: tag, posts: posts} do
    Logger.configure(level: :debug)

    latest_post =
      Ash.load!(tag, :post_written_by_oldest).post_written_by_oldest
      |> Ash.load!(:author)

    assert latest_post.author.age == 41
  end
end
