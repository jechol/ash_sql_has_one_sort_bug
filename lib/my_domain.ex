defmodule MyDomain do
  use Ash.Domain,
    otp_app: :ai_personal_chef

  resources do
    resource MyDomain.Post
    resource MyDomain.Tag
    resource MyDomain.PostTag
    resource MyDomain.Comment
  end
end
