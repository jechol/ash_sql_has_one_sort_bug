defmodule MyDomain.PostTest do
  use AiPersonalChef.DataCase

  alias MyDomain.{Post, Comment}

  setup do
    post =
      Ash.Changeset.for_create(Post, :create)
      |> Ash.create!()

    [~D[2025-01-03], ~D[2025-01-02], ~D[2025-01-05], ~D[2025-01-04], ~D[2025-01-01]]
    |> Enum.each(fn date ->
      Ash.Changeset.for_create(Comment, :create, post_id: post.id, date: date)
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
    assert %{id: 1, date: ~D[2025-01-05]} =
             Ash.load!(post, :latest_comment).latest_comment
  end
end
