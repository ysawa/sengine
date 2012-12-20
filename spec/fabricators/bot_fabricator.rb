# -*- coding: utf-8 -*-

Fabricator(:bot) do
  email { "test_bot#{sequence(:bot)}@example.com" }
  password 'PASSWORD'
  password_confirmation 'PASSWORD'
end
