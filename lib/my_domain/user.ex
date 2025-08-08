defmodule MyDomain.User do
  use Ash.Resource,
    otp_app: :ai_personal_chef,
    domain: MyDomain,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "users"
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
    attribute :age, :integer, allow_nil?: false, public?: true
  end

  relationships do
    has_many :posts, MyDomain.Post do
      public? true
      destination_attribute :author_id
    end
  end
end
