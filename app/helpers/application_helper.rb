# -*- coding: utf-8 -*-

module ApplicationHelper
  def page_name(controller_path, action_name)
    controller_name = controller_path.gsub('/', '.')
    I18n.t("pages.controllers.#{controller_name}.#{action_name}")
  end

  def site_title(subtitle = nil)
    elements = []
    if subtitle.present?
      elements << subtitle
    end
    if Rails.env.production?
      elements << I18n.t('site.title')
    else
      elements << 'Demo'
    end
    elements.join(' | ')
  end
end
