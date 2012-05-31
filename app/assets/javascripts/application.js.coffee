# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery
#= require jquery_ujs
#= require jquery.pjax
#= require jquery.pnotify
#= require_self
#= require jquery.i18n
#= require locales/ja
#= require audio
#= require logic
#= require_directory .

$ ->
  $('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])').pjax('[data-pjax-container]')

$.extend
  notice: (message) ->
    @notice_with_title('Information', message)
  notice_with_title: (title, message) ->
    effect_in = 'scale'
    effect_out = 'scale'
    easing_in = 'easeOutElastic'
    easing_out = 'easeOutElastic'
    speed = 700
    options_in =
      easing: easing_in
    options_out =
      easing: easing_out
    if (effect_in == 'scale')
      options_in.percent = 100
    if (effect_out == 'scale')
      options_out.percent = 0
    $.pnotify(
      pnotify_title: title
      pnotify_text: message
      pnotify_animate_speed: speed
      pnotify_animation:
        'effect_in': effect_in
        'options_in': options_in
        'effect_out': effect_out
        'options_out': options_out
    )
$.fn.extend
  blank: ->
    this.size() == 0
  present: ->
    this.size() > 0
