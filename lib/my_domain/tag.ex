defmodule MyDomain.Tag do
  use Ash.Resource,
    otp_app: :ai_personal_chef,
    domain: MyDomain,
    data_layer: AshPostgres.DataLayer

  require Ash.Sort

  postgres do
    table "tags"
    repo AiPersonalChef.Repo
  end

  actions do
    defaults [:read]

    create :create do
      accept :*
    end
  end

  attributes do
    integer_primary_key :id
    attribute :importance, :integer, allow_nil?: false, default: 0, public?: true
  end

  relationships do
    many_to_many :posts, MyDomain.Post do
      through MyDomain.PostTag
      public? true
    end

    has_one :latest_post, MyDomain.Post do
      public? true
      no_attributes? true
      filter expr(tags.id == parent(id))
      sort date: :desc
    end

    has_one :post_written_by_oldest, MyDomain.Post do
      public? true
      no_attributes? true
      filter expr(tags.id == parent(id))
      sort author_age: :desc
    end
  end
end
