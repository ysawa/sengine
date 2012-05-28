# -*- coding: utf-8 -*-

module ApplicationHelper
  def page_name(controller_path, action_name)
    controller_name = controller_path.gsub('/', '.')
    I18n.t("pages.controllers.#{controller_name}.#{action_name}")
  end
end
