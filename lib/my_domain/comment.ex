defmodule MyDomain.Comment do
  use Ash.Resource,
    otp_app: :ai_personal_chef,
    domain: MyDomain,
    data_layer: AshPostgres.DataLayer

  require Ash.Sort

  postgres do
    table "comments"
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
    attribute :date, :date, public?: true
    attribute :hidden, :boolean, public?: true
  end

  relationships do
    belongs_to :post, MyDomain.Post, allow_nil?: false, public?: true, attribute_type: :integer
  end
end
