# Ash has_one no attribute + complex filter + sort bug

## Symptoms

Post has Tag relationships with both many_to_many and has_one, sorted by importance: :desc. While sorting works for many_to_many, it doesn't work for has_one.

```elixir
  relationships do
    many_to_many :tags, MyDomain.Tag do
      public? true
      through MyDomain.PostTag
      sort importance: :desc
    end

    has_one :most_important_tag, MyDomain.Tag do
      public? true
      no_attributes? true
      filter expr(posts.id == parent(id))
      sort importance: :desc
    end
  end
```


## Reproduction Method

### Failing Test
There is a failing test that can be confirmed with
```shell
$ mix setup
$ mix test
```

## Estimated Cause

When beautifying the query displayed during `mix ecto.reset`, it looks like this:

```sql
SELECT DISTINCT
	p0."id",
	s1."id",
	s1."importance",
	s1."__order__"
FROM
	"public"."posts" AS p0
	INNER JOIN LATERAL (
		SELECT DISTINCT
			ON (st0."id") st0."id" AS "id",
			st0."importance" AS "importance",
			row_number() OVER "order" AS "__order__"
		FROM
			"public"."tags" AS st0
			INNER JOIN "public"."post_tags" AS sp1 ON st0."id" = sp1."tag_id"
			INNER JOIN "public"."posts" AS sp2 ON sp2."id" = sp1."post_id"
		WHERE
			(sp2."id"::bigint = p0."id"::bigint::bigint)
		WINDOW
			"order" AS (
				ORDER BY
					st0."importance" DESC
			)
		ORDER BY
			st0."id",
			st0."importance" DESC
		LIMIT
			1
	) AS s1 ON TRUE
WHERE
	(p0."id"::bigint = ANY ('{81}'::BIGINT[]))
ORDER BY
	s1."__order__"
```

The issue occurs because the unspecified id is placed first in the ORDER BY clause below.
```sql
		ORDER BY
			st0."id",
			st0."importance" DESC
```
