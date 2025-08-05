defmodule MyDomain.PostTag do
  use Ash.Resource,
    otp_app: :ai_personal_chef,
    domain: MyDomain,
    data_layer: AshPostgres.DataLayer

  require Ash.Sort

  postgres do
    table "post_tags"
    repo AiPersonalChef.Repo
  end

  actions do
    defaults [:read]

    create :create do
      accept :*
    end
  end

  relationships do
    belongs_to :post, MyDomain.Post do
      public? true
      allow_nil? false
      primary_key? true
    end

    belongs_to :tag, MyDomain.Tag do
      public? true
      allow_nil? false
      primary_key? true
    end
  end
end
