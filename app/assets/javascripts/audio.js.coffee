$.extend
  audio:
    enabled: false
    schemes: {}
    tag_support: !!(document.createElement('audio').canPlayType)
    disable: () ->
      @enabled = false
    enable: () ->
      @enabled = true
    find_enabled_format: ->
      if @tag_support
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
    initialize: (audio) ->
      if @enabled
        if @tag_support
          format = @find_enabled_format()
          @schemes[audio] = null
          if format
            $.get(
              "/audio/encode/#{audio}#{format}",
              (data) ->
                $.audio.schemes[audio] = data
            )
    play: (audio) ->
      if @enabled
        if @tag_support
          if @schemes[audio]
            audio = new Audio(@schemes[audio])
            audio.volume = 1.0
            audio.play()
          else
            @initialize(audio)
        else if $.browser.msie
          $("bgsound").remove()
          bgsound = $("<bgsound>")
          bgsound.attr(src: "/assets/audio/#{audio}.wav")
          $('body').append(bgsound)
