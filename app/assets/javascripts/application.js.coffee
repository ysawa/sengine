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
#= require jquery-ui
#= require jquery_ujs
#= require twitter/bootstrap/bootstrap-button
#= require twitter/bootstrap/bootstrap-collapse
#= require twitter/bootstrap/bootstrap-dropdown
#= require twitter/bootstrap/bootstrap-tab
#= require twitter/bootstrap/bootstrap-tooltip
#= require twitter/bootstrap/bootstrap-popover
#= require jquery.pjax
#= require jquery.pnotify
#= require jquery-validation/jquery.validate
#= require jquery-animate-css-rotate-scale
#= require underscore
#= require backbone
#= require_directory ./helpers/
#= require audio
#= require shogi/shogi
#= require_directory ./shogi/
#= require_self
#= require_directory .

$ ->
  ###
  # Features as Application
  ###

  $('.whole_container').css('min-height', $(window).height())

  $('body').on('click', '.nav-collapse a', ->
    $(this).parents('.nav-collapse').collapse('hide')
  )
  $.validator.setDefaults
    errorPlacement: (error, element) ->
      error.insertBefore(element)

  # Triggers of PJAX
  $('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])').pjax('[data-pjax-container]')

  # After PJAX requests, we can operate callbacks as we like.
  on_pjax_reload = ->
    # Validations of Forms
    $('form.validated').validate(
    )
    body_class = $('body').attr('class')
    body_class = body_class.replace(/theme_\w+/, '').replace(/\s+/, ' ')
    $('body').attr('class', body_class)
    if $('#game').present()
      theme = $('#game').attr('game-theme')
      $('body').addClass("theme_#{theme}")
    else
      $('body').addClass('theme_default')

  $(document).on('pjax:end', on_pjax_reload)
  on_pjax_reload()

  $('a.see_more').live 'click', ->
    $(this).hide()
  if ($.check_if_smart_device())
    # smart phone
    true

  ###
  # Features around Facebook
  ###

  # Raw application in Facebook is not good.
  # Redirect to apps.facebook.com as a native facebook app.
  if self != top
    top.location.href = self.location.href.replace(/\?.+$/, '')
  $('a.invite_facebook').live 'click', ->
    if $.check_if_facebook_enabled()
      $.invite_facebook()
    false

  $('a[target="_blank"]').live 'click', ->
    if $.check_if_facebook_enabled()
      href = $(this).attr('href')
      if $.check_if_outside_url(href)
        $.google_analytics_track_pageview(href)

  # observer = new PushObserver
  # observer.observe()

$.extend
  check_if_inside_url: (url) ->
    host = location.host
    if url.match(/^\//)
      true
    else if url.match(new RegExp("^http(|s)://#{host}"))
      true
    else
      false
  check_if_smart_device: ->
    useragent = navigator.userAgent
    useragent.match(/(iPad|iPhone|Android)/i)
  check_if_outside_url: (url) ->
    !check_if_inside_url(url)
  reload_notices: ->
    $.ajax
      type: "GET"
      url: "/notices.js"
      dataType: "script"
      timeout: 10000
