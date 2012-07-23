#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require jquery.pjax
#= require jquery.pnotify
#= require jquery-validation/jquery.validate
#= require_directory ../helpers/
#= require_self
#= require_directory .

$ ->
  $('.whole_container').css('min-height', $(window).height())

$.extend
  check_if_facebook_enabled: ->
    typeof FB != "undefined"
