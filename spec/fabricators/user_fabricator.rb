Fabricator(:user) do
  email { "test#{sequence(:user)}@example.com" }
  password 'testtest'
  password_confirmation 'testtest'
end
