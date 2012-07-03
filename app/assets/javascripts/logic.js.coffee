###
# Game logics of Shogi
# TODO refactor: it should be implemented not $, but Shogi
###
$.fn.extend
  have_piece: ->
    $(this).find('.piece').size() > 0
  highlight_orbit: ->
    x = $(this).point_x()
    y = $(this).point_y()
    role = $(this).attr('role')
    sente = $(this).attr('direction') == 'sente'
    direction = +1
    unless sente
      direction = -1
    if role == 'fu'
      $.highlight_on_point_if_possible([x, y - 1 * direction])
    else if role == 'ke'
      for i in [-1, 1]
        $.highlight_on_point_if_possible([x + i, y - 2 * direction])
    else if role == 'ou'
      for i in [-1, 0, 1]
        this_x = x + i
        for j in [-1, 1]
          this_y = y + j
          $.highlight_on_point_if_possible([this_x, this_y])
      for i in [-1, 1]
        $.highlight_on_point_if_possible([x + i, y])
    else if role == 'gi'
      for i in [-1, 0, 1]
        this_x = x + i
        for j in [-1, 1]
          this_y = y + j * direction
          $.highlight_on_point_if_possible([this_x, this_y])
      $.cell_on_point([x, y + 1 * direction]).removeClass('highlight')
    else if $.inArray(role, ['ki', 'to', 'ny', 'nk', 'ng']) != -1
      for i in [-1, 0, 1]
        $.highlight_on_point_if_possible([x + i, y - 1 * direction])
      for i in [-1, 1]
        $.highlight_on_point_if_possible([x + i, y])
      $.highlight_on_point_if_possible([x, y + 1 * direction])
    else if role == 'ky'
      highlight_cells = (point) ->
        if $.cell_on_point_have_proponent_piece(point)
          false
        else if $.cell_on_point_have_opponent_piece(point)
          $.highlight_on_point(point)
          false
        else
          $.highlight_on_point(point)
          true
      for i in [1..8]
        point = [x, y - i * direction]
        if $.cell_on_point_have_proponent_piece(point)
          break
        else
          $.highlight_on_point(point)
    else if $.inArray(role, ['hi', 'ry']) != -1
      highlight_cells = (point) ->
        if $.cell_on_point_have_proponent_piece(point)
          false
        else if $.cell_on_point_have_opponent_piece(point)
          $.highlight_on_point(point)
          false
        else
          $.highlight_on_point(point)
          true
      for number_loop in [[-1..-8], [1..8]]
        for i in number_loop
          point = [x, y + i]
          break unless highlight_cells(point)
        for i in number_loop
          point = [x + i, y]
          break unless highlight_cells(point)
    else if $.inArray(role, ['ka', 'um']) != -1
      highlight_cells = (point) ->
        if $.cell_on_point_have_proponent_piece(point)
          false
        else if $.cell_on_point_have_opponent_piece(point)
          $.highlight_on_point(point)
          false
        else
          $.highlight_on_point(point)
          true
      for number_loop in [[-1..-8], [1..8]]
        for i in number_loop
          point = [x + i, y + i]
          break unless highlight_cells(point)
        for i in number_loop
          point = [x - i, y + i]
          break unless highlight_cells(point)
    if role == 'ry'
      for i in [-1, 1]
        for j in [-1, 1]
          $.highlight_on_point_if_possible([x + i, y + j])
    else if role == 'um'
      for i in [-1, 1]
        $.highlight_on_point_if_possible([x, y + i])
        $.highlight_on_point_if_possible([x + i, y])
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
  board_turn: ->
    $('.board').attr('turn')
  cell_on_point: (point) ->
    x = point[0]
    y = point[1]
    $(".cell[x=\"#{x}\"][y=\"#{y}\"]")
  cell_on_point_have_piece: (point) ->
    cell = $.cell_on_point(point)
    if cell.find('.piece').size() >= 1
      true
    else
      false
  cell_on_point_have_opponent_piece: (point) ->
    cell = $.cell_on_point(point)
    if cell.find('.piece').size() >= 1
      cell.find('.piece').attr('direction') != $.board_turn()
    else
      false
  cell_on_point_have_proponent_piece: (point) ->
    cell = $.cell_on_point(point)
    if cell.find('.piece').size() >= 1
      cell.find('.piece').attr('direction') == $.board_turn()
    else
      false
  cell_on_column_have_proponent_fu: (column) ->
    x = column
    result = false
    for y in [1..9]
      cell = @cell_on_point([x, y])
      piece = cell.find('.piece')
      if piece.size() >= 1
        if piece.attr('direction') == $.board_turn() and piece.attr('role') is 'fu'
          result = true
          break
    result

  highlight_on_point: (point) ->
    x = point[0]
    y = point[1]
    $.cell_on_point([x, y]).addClass('highlight')
  highlight_on_point_if_possible: (point) ->
    unless $.cell_on_point_have_proponent_piece(point)
      $.highlight_on_point(point)
  roles: ['fu', 'gi', 'ke', 'ky', 'ka', 'hi', 'ou', 'ki']
  reversed_roles: ['to', 'ng', 'nk', 'ny', 'um', 'ry', 'ou', 'ki']

