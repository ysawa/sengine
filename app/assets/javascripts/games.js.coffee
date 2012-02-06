$ ->
  $('.piece.upward').live 'click', ->
    unless $(this).attr('direction') == $.board_turn()
      return
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
    piece_cell = piece_selected.parents('.cell')
    $('.cell').removeClass('highlight')
    piece_selected.removeClass('selected')
    game_id = $('.board').attr('game_id')
    $.ajax
      asyn: false
      type: "POST"
      url: "/games/#{game_id}/movements"
      data:
        movement:
          role: piece_selected.attr('role')
          from_point: [piece_cell.attr('x'), piece_cell.attr('y')]
          to_point: [$(this).attr('x'), $(this).attr('y')]
          move: true
          put: false
          reverse: false
          sente: piece_selected.attr('direction') == 'sente'
    $(this).append(piece_selected)
    turn = $('.board').attr('turn')
    if turn == 'sente'
      $('.board').attr('turn', 'gote')
    else
      $('.board').attr('turn', 'sente')

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
    else if role == 'keima'
      for i in [-1, 1]
        $.highlight_on_point_if_possible([x + i, y - 2 * direction])
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
          this_y = y + j * direction
          $.highlight_on_point_if_possible([this_x, this_y])
      $.cell_on_point([x, y + 1 * direction]).removeClass('highlight')
    else if $.inArray(role, ['kin', 'tokin', 'narikyo', 'narikei', 'narigin']) != -1
      for i in [-1, 0, 1]
        $.highlight_on_point_if_possible([x + i, y - 1 * direction])
      for i in [-1, 1]
        $.highlight_on_point_if_possible([x + i, y])
      $.highlight_on_point_if_possible([x, y + 1 * direction])
    else if role == 'kyosha'
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
    else if role == 'hisha'
      highlight_cells = (point) ->
        if $.cell_on_point_have_proponent_piece(point)
          false
        else if $.cell_on_point_have_opponent_piece(point)
          $.highlight_on_point(point)
          false
        else
          $.highlight_on_point(point)
          true
      for i in [-1..-8]
        point = [x, y + i]
        break unless highlight_cells(point)
      for i in [1..8]
        point = [x, y + i]
        break unless highlight_cells(point)
      for i in [-1..-8]
        point = [x + i, y]
        break unless highlight_cells(point)
      for i in [1..8]
        point = [x + i, y]
        break unless highlight_cells(point)
    else if role == 'kaku'
      highlight_cells = (point) ->
        if $.cell_on_point_have_proponent_piece(point)
          false
        else if $.cell_on_point_have_opponent_piece(point)
          $.highlight_on_point(point)
          false
        else
          $.highlight_on_point(point)
          true
      for i in [-1..-8]
        point = [x + i, y + i]
        break unless highlight_cells(point)
      for i in [1..8]
        point = [x + i, y + i]
        break unless highlight_cells(point)
      for i in [-1..-8]
        point = [x - i, y + i]
        break unless highlight_cells(point)
      for i in [1..8]
        point = [x - i, y + i]
        break unless highlight_cells(point)
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
  highlight_on_point: (point) ->
    x = point[0]
    y = point[1]
    $.cell_on_point([x, y]).addClass('highlight')
  highlight_on_point_if_possible: (point) ->
    unless $.cell_on_point_have_proponent_piece(point)
      $.highlight_on_point(point)
  board_turn: ->
    $('.board').attr('turn')
