# Ash many_to_many sort bug

## Symptoms

Post has a many_to_many relationship with tags, which is a sorted list of Tags based on the position attribute of the join table PostTag.

```elixir
    many_to_many :tags, MyDomain.Tag do
      public? true
      through MyDomain.PostTag
      join_relationship :post_tags
      sort [Ash.Sort.expr_sort(post_tags.position)]
    end
```

When the Post and PostTag tables are empty, it shows properly sorted results,
but when there are other Posts and PostTags, there is a bug where the sort doesn't work correctly.

## Reproduction Method

### Failing Test
There is a failing test that can be confirmed with
```shell
$ mix setup
$ mix test
```

### Seeding the failing case in dev database
```shell
$ mix setup
$ mix ecto.reset
```

I've set it up to display queries that show the symptoms as follows.

```
22:48:10.315 [error] Below query is not working as expected. (post.id: 2)

22:48:10.367 [debug] QUERY OK source="posts" db=1.6ms
SELECT DISTINCT p0."id", s1."id", s1."__order__" FROM "public"."posts" AS p0 INNER JOIN LATERAL (SELECT DISTINCT ON (st0."id") st0."id" AS "id", row_number() OVER "order" AS "__order__" FROM "public"."tags" AS st0 INNER JOIN "public"."post_tags" AS sp1 ON st0."id" = sp1."tag_id" INNER JOIN "public"."post_tags" AS sp2 ON sp2."tag_id" = st0."id" WHERE (sp2."post_id" = p0."id") WINDOW "order" AS (ORDER BY sp1."position"::bigint) ORDER BY st0."id", sp1."position"::bigint) AS s1 ON TRUE WHERE (p0."id"::bigint = ANY('{2}'::bigint[])) AND (p0."id" = ANY('{2}')) ORDER BY s1."__order__"

22:48:10.368 [error] Expected tags are ["tag1", "tag3", "tag5", "tag4", "tag2"].

22:48:10.368 [error] Result tags are ["tag1", "tag2", "tag3", "tag5", "tag4"].
```

## Estimated Cause

When beautifying the query displayed during `mix ecto.reset`, it looks like this:

```sql
SELECT DISTINCT
  p0."id",
  s1."id",
  s1."__order__"
FROM
  "public"."posts" AS p0
  INNER JOIN LATERAL (
    SELECT DISTINCT
      ON (st0."id") st0."id" AS "id",
      row_number() OVER "order" AS "__order__"
    FROM
      "public"."tags" AS st0
      INNER JOIN "public"."post_tags" AS sp1 ON st0."id" = sp1."tag_id" --- (1)
      INNER JOIN "public"."post_tags" AS sp2 ON sp2."tag_id" = st0."id" --- (2)
    WHERE
      (sp2."post_id" = p0."id") --- (3)
    WINDOW
      "order" AS (
        ORDER BY
          sp1."position"::bigint
      )
    ORDER BY
      st0."id",
      sp1."position"::bigint
  ) AS s1 ON TRUE
WHERE
  (p0."id"::bigint = ANY ('{2}'::BIGINT[]))
  AND (p0."id" = ANY ('{2}'))
ORDER BY
  s1."__order__"
```

The post_tags `sp2` joined in (2) is filtered by the corresponding post id in (3),
but the post_tags `sp1` joined in (1) is not filtered, causing joins with post ids that are different.
