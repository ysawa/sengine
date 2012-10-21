$.extend
  check_if_facebook_enabled: ->
    return false if ($.browser.msie && parseInt($.browser.version) < 8)
    typeof FB != "undefined"
  fix_facebook_comments_height: ->
    height = $('.fb_comments iframe').height()
    iframe = $('.fb_comments, .fb_comments iframe')
    if height == 160
      iframe.height(140)
    else if height == 480
      # TODO fix the height
    else
      iframe.height(height)
  invite_facebook: ->
    FB.ui
      method: 'apprequests'
      message: $.i18n.t('invite_facebook_message')
      title: $.i18n.t('invite_facebook_title')
  reload_comments: ->
    comments = $('div.fb_comments').children()
    comments.html('')
    comments.removeClass('fb_iframe_widget')
    html = $('div.fb_comments').get(0).innerHTML
    $('div.fb_comments').html(html)
    $.reparse_xfbml()
  reparse_xfbml: ->
    FB.XFBML.parse()
