defmodule MyDomain.Post do
  use Ash.Resource,
    otp_app: :ai_personal_chef,
    domain: MyDomain,
    data_layer: AshPostgres.DataLayer

  require Ash.Sort

  postgres do
    table "posts"
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
  end

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

    has_one :latest_hidden_comment, MyDomain.Comment do
      public? true
      from_many? true
      filter expr(hidden == true)
      sort date: :desc
    end
  end
end
