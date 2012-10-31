# -*- coding: utf-8 -*-

Fabricator(:minna_bot) do
  email { "test_minna_bot#{sequence(:minna_bot)}@example.com" }
  password 'testtest'
  password_confirmation 'testtest'
end
