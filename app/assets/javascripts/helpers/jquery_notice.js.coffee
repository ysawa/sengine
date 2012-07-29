$.extend
  notice: (message) ->
    @notice_with_title('Information', message)
  notice_with_title: (title, message) ->
    $.pnotify(
      pnotify_title: title
      pnotify_text: message
    )
