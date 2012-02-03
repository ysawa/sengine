$ ->
  $('.piece.upward').live 'click', ->
    $('.cell').removeClass('highlight')
    if $(this).hasClass('selected')
      $('.piece').removeClass('selected')
    else
      $('.piece').removeClass('selected')
      $(this).highlight_orbit()
      $(this).addClass('selected')

  $('.cell.highlight').live 'click', ->
    $.put_audio()
    piece_selected = $('.piece.selected')
    $('.cell').removeClass('highlight')
    piece_selected.removeClass('selected')
    $(this).append(piece_selected)

$.fn.extend
  have_piece: ->
    $(this).find('.piece').size() > 0
  highlight_orbit: ->
    x = $(this).point_x()
    y = $(this).point_y()
    role = $(this).attr('role')
    if role == 'fu'
      $.highlight_on_point_if_possible([x, y - 1])
    else if role == 'keima'
      for i in [-1, 1]
        $.highlight_on_point_if_possible([x + i, y - 2])
    else if role == 'gyoku'
      for i in [-1, 0, 1]
        this_x = x + i
        for j in [-1, 1]
          this_y = y + j
          $.highlight_on_point_if_possible([this_x, this_y])
      for i in [-1, 1]
        $.highlight_on_point_if_possible([x + i, y])
    else if role == 'gin'
      for i in [-1, 0, 1]
        this_x = x + i
        for j in [-1, 1]
          this_y = y + j
          $.highlight_on_point_if_possible([this_x, this_y])
      $.cell_on_point([x, y + 1]).removeClass('highlight')
    else if $.inArray(role, ['kin', 'tokin', 'narikyo', 'narikei', 'narigin']) != -1
      for i in [-1, 0, 1]
        $.highlight_on_point_if_possible([x + i, y - 1])
      for i in [-1, 1]
        $.highlight_on_point_if_possible([x + i, y])
      $.highlight_on_point_if_possible([x, y + 1])
    else if role == 'kyosha'
      for i in [1..8]
        if $.cell_on_point_have_piece([x, y - i])
          break
        else
          $.highlight_on_point([x, y - i])
    else if role == 'hisha'
      for i in [-1..-8]
        if $.cell_on_point_have_piece([x, y + i])
          break
        else
          $.highlight_on_point([x, y + i])
      for i in [-1..-8]
        if $.cell_on_point_have_piece([x + i, y])
          break
        else
          $.highlight_on_point([x + i, y])
      for i in [1..8]
        if $.cell_on_point_have_piece([x + i, y])
          break
        else
          $.highlight_on_point([x + i, y])
      for i in [1..8]
        if $.cell_on_point_have_piece([x, y + i])
          break
        else
          $.highlight_on_point([x, y + i])
    else if role == 'kaku'
      for i in [-1..-8]
        if $.cell_on_point_have_piece([x + i, y + i])
          break
        else
          $.highlight_on_point([x + i, y + i])
      for i in [1..8]
        if $.cell_on_point_have_piece([x + i, y + i])
          break
        else
          $.highlight_on_point([x + i, y + i])
      for i in [-1..-8]
        if $.cell_on_point_have_piece([x - i, y + i])
          break
        else
          $.highlight_on_point([x - i, y + i])
      for i in [1..8]
        if $.cell_on_point_have_piece([x - i, y + i])
          break
        else
          $.highlight_on_point([x - i, y + i])
  point_x: ->
    if $(this).hasClass('piece')
      parseInt $(this).parents('.cell').attr('x')
    else if $(this).hasClass('cell')
      parseInt $(this).attr('x')
  point_y: ->
    if $(this).hasClass('piece')
      parseInt $(this).parents('.cell').attr('y')
    else if $(this).hasClass('cell')
      parseInt $(this).attr('y')
$.extend
  cell_on_point: (point) ->
    x = point[0]
    y = point[1]
    $(".cell[x=\"#{x}\"][y=\"#{y}\"]")
  cell_on_point_have_piece: (point) ->
    $.cell_on_point(point).have_piece()
  highlight_on_point: (point) ->
    x = point[0]
    y = point[1]
    $.cell_on_point([x, y]).addClass('highlight')
  highlight_on_point_if_possible: (point) ->
    unless $.cell_on_point_have_piece(point)
      $.highlight_on_point(point)

