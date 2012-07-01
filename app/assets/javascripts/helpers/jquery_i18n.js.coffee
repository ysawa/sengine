#= require jquery.i18n
#= require ./locales/ja
#= require ./locales/en

$.extend
  set_locale: (locale) ->
    if locale == 'en'
      $.set_locale_en()
    else if locale == 'ja'
      $.set_locale_ja()
    null

