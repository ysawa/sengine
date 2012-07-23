# -*- coding: utf-8 -*-

class ApplicationDecorator < Draper::Base

  %w(created_at updated_at).each do |attr_name|
    class_eval <<-EOS
      def #{attr_name}(options = {})
        time = model.read_attribute(:#{attr_name})
        if time
          h.time_tag time, localize_time(time, options)
        end
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

  def user_admin?
    user_signed_in? && current_user.admin?
  end

protected

  def extract_links(html, options = {})
    uris = []
    URI.extract(html, %w(http https)).each do |uri|
      next if uris.include?(uri)
      html.gsub!(uri, h.link_to(h.truncate(uri, length: 40), uri, options))
      uris << uri
    end
    html.html_safe
  end

  def prettify(text)
    if text.present?
      html = ERB::Util.html_escape(text).gsub(/(\r\n|\r|\n)/, '<br>').html_safe
      extract_links(html)
    else
      ''
    end
  end
end
