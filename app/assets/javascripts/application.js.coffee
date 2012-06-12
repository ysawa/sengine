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
#= require jquery-validation/jquery.validate
#= require_self
#= require jquery.i18n
#= require locales/ja
#= require audio
#= require logic
#= require_directory .

$ ->
  $('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])').pjax('[data-pjax-container]')
  $('form.validated').validate()
  $('a.see_more').live 'click', ->
    $(this).hide()
  if ($.check_if_smart_device())
    # smart phone
    true
  $('a.invite_facebook').live 'click', ->
    $.invite_facebook()
    false

  # reloading facebook comments automatically if enabled
  setInterval(
    ->
      condition = $.check_if_facebook_enabled()
      condition &&= $('input[name="reload_comments"]').attr('checked')
      if condition
        $.reload_comments()
    , 10000)

$.extend
  check_if_facebook_enabled: ->
    typeof FB != "undefined"
  check_if_smart_device: ->
    useragent = navigator.userAgent
    useragent.match(/(iPad|iPhone|Android)/i)
  invite_facebook: ->
    FB.ui
      method: 'apprequests'
      message: $.i18n.t('invite_facebook_message')
      title: $.i18n.t('invite_facebook_title')
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
  reload_comments: ->
    comments = $('div.fb_comments').children()
    comments.html('')
    comments.removeClass('fb_iframe_widget')
    html = $('div.fb_comments').get(0).innerHTML
    $('div.fb_comments').html(html)
    $.reparse_xfbml()
  reparse_xfbml: ->
    FB.XFBML.parse()

$.fn.extend
  blank: ->
    this.size() == 0
  present: ->
    this.size() > 0
