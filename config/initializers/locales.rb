# -*- coding: utf-8 -*-

module Sengine
  locales = []
  Dir.entries(File.join(Rails.root, 'config/locales')).each do |entry|
    next if entry == '.' || entry == '..'
    locales << entry.to_sym
  end
  LOCALES = locales
end
