# -*- coding: utf-8 -*-

<% module_namespacing do -%>
class <%= class_name %>Controller < ApplicationController
<% actions.sort.each do |action| -%>
  def <%= action %>
  end
<%= "\n" unless action == actions.sort.last -%>
<% end -%>
end
<% end -%>
