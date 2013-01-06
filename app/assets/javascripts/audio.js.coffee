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
        audio_tag = new Audio("")
        # select the supported and shortest audio format
        if ("" != audio_tag.canPlayType("audio/ogg"))
          '.ogg'
        else if ("" != audio_tag.canPlayType("audio/mpeg"))
          '.mp3'
        else
          '.wav'
      else
        null
    initialize: (scheme) ->
      if @enabled
        if @tag_support
          format = @find_enabled_format()
          @schemes[scheme] = null
          if format
            $.get(
              "/audio/encode/#{scheme}#{format}",
              (data) ->
                $.audio.schemes[scheme] = data
            )
    play: (scheme) ->
      if @enabled
        if @tag_support
          if @schemes[scheme]
            audio_tag = new Audio(@schemes[scheme])
            audio_tag.volume = 1.0
            audio_tag.play()
          else
            @initialize(scheme)
        else if $.browser.msie
          $("bgsound").remove()
          bgsound = $("<bgsound>")
          bgsound.attr(src: "/assets/audio/#{scheme}.wav")
          $('body').append(bgsound)
