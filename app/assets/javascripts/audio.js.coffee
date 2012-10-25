$.extend
  audio_enabled: false
  audio_schemes: {}
  audio_tag_support: !!(document.createElement('audio').canPlayType)
  disable_audio: () ->
    @audio_enabled = false
  enable_audio: () ->
    @audio_enabled = true
  find_enabled_audio_format: ->
    if @audio_tag_support
      audio = new Audio("")
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
    if @audio_tag_support
      format = @find_enabled_audio_format()
      @audio_schemes.put = null
      if format
        $.get(
          "/audio/encode/#{audio}#{format}",
          (data) ->
            $.audio_schemes[audio] = data
        )
  play_audio: (audio) ->
    if @audio_enabled
      if @audio_tag_support
        if @audio_schemes[audio]
          audio = new Audio(@audio_schemes[audio])
          audio.volume = 1.0
          audio.play()
      else if $.browser.msie
        $("bgsound").remove()
        bgsound = $("<bgsound>")
        bgsound.attr(src: "/assets/audio/#{audio}.wav")
        $('body').append(bgsound)
