# -*- coding: utf-8 -*-

Fabricator(:bot) do
  email { "test#{sequence(:bot)}@example.com" }
  password 'testtest'
  password_confirmation 'testtest'
end
