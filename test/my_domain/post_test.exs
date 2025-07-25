defmodule MyDomain.PostTest do
  use AiPersonalChef.DataCase

  alias MyDomain.{Post, Comment}

  setup do
    post =
      Ash.Changeset.for_create(Post, :create)
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

  test "has_many", %{post: post} do
    assert [
             %{date: ~D[2025-01-05]},
             %{date: ~D[2025-01-04]},
             %{date: ~D[2025-01-03]},
             %{date: ~D[2025-01-02]},
             %{date: ~D[2025-01-01]}
           ] = Ash.load!(post, :comments).comments
  end

  test "has_one", %{post: post} do
    Logger.configure(level: :debug)

    assert %{date: ~D[2025-01-05]} =
             Ash.load!(post, :latest_comment).latest_comment
  end

  test "has_one with filter", %{post: post} do
    assert %{date: ~D[2025-01-04]} =
             Ash.load!(post, :latest_hidden_comment).latest_hidden_comment
  end
end
