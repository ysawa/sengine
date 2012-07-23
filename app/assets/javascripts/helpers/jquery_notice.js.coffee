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
