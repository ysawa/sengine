# -*- coding: utf-8 -*-

class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :make_subtitle
protected
  def make_subtitle(ref_name = nil)
    base_name = controller_path.gsub('/', '.')
    ref_name ||= action_name
    action_names = I18n.t("pages.controllers.#{base_name}")
    case action_names
    when Hash
      @subtitle = action_names[ref_name.to_sym]
    else
      @subtitle = nil
    end
  end
end
