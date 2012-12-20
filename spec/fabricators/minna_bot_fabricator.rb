# -*- coding: utf-8 -*-

Fabricator(:minna_bot) do
  email { "test_minna_bot#{sequence(:minna_bot)}@example.com" }
  password 'PASSWORD'
  password_confirmation 'PASSWORD'
end
