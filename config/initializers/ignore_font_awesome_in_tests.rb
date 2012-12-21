# -*- coding: utf-8 -*-

# 8/16/2012
# This is here specifically for font awesome. It causes QT and capybara-webkit
# to crash while trying to load the font.
# If you are aware of any better way to take care of this problem, let
# me know!
if Rails.env.test?
  Rails.application.config.assets.paths.reject! { |path| path.to_s =~ /fonts/ }
end
