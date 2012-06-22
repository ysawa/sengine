# -*- coding: utf-8 -*-

class ApplicationDecorator < Draper::Base

  %w(created_at updated_at).each do |attr_name|
    class_eval <<-EOS
      def #{attr_name}(options = {})
        time = model.read_attribute(:#{attr_name})
        localize_time(time, options)
      end
    EOS
  end

  def current_user
    h.current_user
  end

  def localize_date(date, options = {})
    if date
      target = date.to_date
      I18n.l(target, options)
    end
  end

  def localize_time(time, options = {})
    if time
      target = time.to_time.in_time_zone
      I18n.l(target, options)
    end
  end

  def user_signed_in?
    h.user_signed_in?
  end
end
