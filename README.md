# Ash has_one sort bug

## Symptoms

Post 는 Post를 date: :desc로 soring해서 has_many 와 has_one 으로 가지는데, has_many에는 sort가 작동하지만, has_one에서는 작동하지 않음.

```elixir
  relationships do
    has_many :comments, MyDomain.Comment do
      public? true
      sort date: :desc
    end

    has_one :latest_comment, MyDomain.Comment do
      public? true
      from_many? true
      sort date: :desc
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
