$.fn.extend
  form_slider: ->
    slider = $(this)
    slider_width = slider.width()
    slides = slider.children('.slides')
    slide_width = slides.children('.slide').innerWidth()
    slides_size = slides.children('.slide').size()
    slides_width = slide_width * slides_size
    slides.width(slides_width)
    enabled = false
    if slides_width > slider_width
      enabled = true
      slider.children('.left, .right').removeClass('disabled')
    else
      slider.children('.left, .right').addClass('disabled')
    if enabled
      position = 0
      max_position = Math.ceil((slides_width - slider_width) / slide_width)
      slider.children('.left').bind('click', ->
        return if position >= max_position
        slides.animate({
          left: "-=#{slide_width}"
        })
        position += 1
      )
      slider.children('.right').bind('click', ->
        return if position == 0
        slides.animate({
          left: "+=#{slide_width}"
        })
        position -= 1
      )
