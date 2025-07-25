alias MyDomain.{Post, Tag}

# Insert tags
["tag1", "tag2", "tag3", "tag4", "tag5", "tag6", "tag7", "tag8", "tag9", "tag10"]
|> Enum.each(fn tag ->
  Ash.Changeset.for_create(Tag, :create, %{id: tag})
  |> Ash.create!()
end)

# Noise post
Ash.Changeset.for_create(Post, :create,
  text: "post",
  tags: ["tag1", "tag2", "tag3", "tag4", "tag5", "tag6", "tag7", "tag8", "tag9", "tag10"]
)
|> Ash.create!()

expected_tags = ["tag1", "tag3", "tag5", "tag4", "tag2"]

# Target post
Ash.Changeset.for_create(Post, :create,
  text: "post",
  tags: expected_tags
)
|> Ash.create!()
|> tap(fn post ->
  require Logger
  Logger.error("Below query is not working as expected. (post.id: #{post.id})")
  Logger.configure(level: :debug)
  post = Ash.load!(post, :tags)

  Logger.error("Expected tags are #{inspect(expected_tags)}.")
  result_tags = post.tags |> Enum.map(& &1.id)
  Logger.error("Result tags are #{inspect(result_tags)}.")
end)
