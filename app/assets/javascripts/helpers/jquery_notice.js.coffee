$.extend
  notice: (message, type = null) ->
    @notice_with_title('Information', message)
  notice_with_title: (title, message, type = null) ->
    $.pnotify(
      title: title
      text: message
      type: type
      hide: false
      styling: 'jqueryui'
    )
