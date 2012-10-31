# -*- coding: utf-8 -*-

Fabricator(:official_bot) do
  email { "test_official_bot#{sequence(:official_bot)}@example.com" }
  password 'testtest'
  password_confirmation 'testtest'
end
