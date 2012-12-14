# -*- coding: utf-8 -*-

Fabricator(:tag) do
  name    "Tag Name"
  code    "tag_name"
  content <<-EOS
This Is a Tag Content.
Good!
EOS
end
