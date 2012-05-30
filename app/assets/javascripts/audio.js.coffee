$.extend
  audio_schemes: {}
  audio_tag_support: !!(document.createElement('audio').canPlayType)
  find_enabled_audio_format: ->
    audio = new Audio("")
    if @audio_tag_support
      # select the supported and shortest audio format
      if ("" != audio.canPlayType("audio/ogg"))
        '.ogg'
      else if ("" != audio.canPlayType("audio/mpeg"))
        '.mp3'
      else
        '.wav'
    else
      null
  initialize_audio: (audio) ->
    format = @find_enabled_audio_format()
    if @audio_tag_support
      @audio_schemes.put = null
      $.get(
        "/audio/encode/#{audio}#{format}",
        (data) ->
          $.audio_schemes[audio] = data
      )
  play_audio: (audio) ->
    if @audio_tag_support
      if @audio_schemes[audio]
        audio = new Audio(@audio_schemes[audio])
        audio.play()
