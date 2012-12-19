Fabricator(:user) do
  content <<-EOS
Shall we play shogi?
Oh, my goodness.
EOS
  name 'User Name'
  email { "test#{sequence(:user)}@example.com" }
  password 'testtest'
  password_confirmation 'testtest'
end
