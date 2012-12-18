# -*- coding: utf-8 -*-

module Sengine
  locales = []
  locale_strings = []
  Dir.entries(File.join(Rails.root, 'config/locales')).each do |entry|
    next if entry == '.' || entry == '..'
    locale_strings << entry
    locales << entry.to_sym
  end
  LOCALES = locales
  LOCALE_STRINGS = locale_strings
end
