$ ->
  $('.board, .in_hand').disableSelection()
  $('.board .piece.upward').live 'click', ->
    unless $(this).attr('direction') == $.board_turn()
      return
    $('.cell').removeClass('highlight')
    if $(this).hasClass('selected')
      $('.piece').removeClass('selected')
    else
      $('.piece').removeClass('selected')
      $(this).highlight_orbit()
      $(this).addClass('selected')

  $('.in_hand .piece.upward').live 'click', ->
    unless $(this).attr('direction') == $.board_turn()
      return
    $('.cell').removeClass('highlight')
    if $(this).hasClass('selected')
      $('.piece').removeClass('selected')
    else
      $('.piece').removeClass('selected')
      $(this).addClass('selected')
      first_line = 1
      last_line = 9
      if $.inArray($(this).attr('role'), ['fu', 'kyosha']) >= 0
        if $(this).attr('direction') == 'gote'
          last_line = 8
        else
          first_line = 2
      else if $(this).attr('role') == 'keima'
        if $(this).attr('direction') == 'gote'
          last_line = 7
        else
          first_line = 3
      for x in [1..9]
        for y in [first_line..last_line]
          point = [x, y]
          unless $.cell_on_point_have_piece(point)
            $.highlight_on_point(point)

  $('.cell.highlight').live 'click', ->
    $.put_audio()
    move = true
    piece_selected = $('.piece.selected')
    role = piece_selected.attr('role')
    if piece_selected.parents('.in_hand').size() >= 1
      move = false
    piece_cell = piece_selected.parents('.cell')
    from_point = null
    if move
      from_point = [piece_cell.point_x(), piece_cell.point_y()]
    to_point = [$(this).point_x(), $(this).point_y()]
    $('.cell').removeClass('highlight')
    piece_selected.removeClass('selected')
    game_id = $('.board').attr('game_id')
    movement =
      role: role
      move: move
      put: !move
      to_point: to_point
      reverse: false
      sente: piece_selected.attr('direction') == 'sente'
    movement.from_point = from_point if from_point
    $.ajax
      asyn: false
      type: "POST"
      url: "/games/#{game_id}/movements"
      data:
        movement: movement
    if $.cell_on_point_have_opponent_piece(to_point)
      piece = $.cell_on_point(to_point).find('.piece')
      piece.attr('direction', piece_selected.attr('direction'))
      piece.removeClass('downward')
      piece.addClass('upward')
      $('.in_hand.upward .pieces .row').append('<div class="cell"></div>')
      $('.in_hand.upward .pieces .row .cell:last').append(piece)
    $(this).append(piece_selected)
    $('.in_hand .cell').each ->
      if $(this).find('.piece').size() == 0
        $(this).remove()
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
      for number_loop in [[-1..-8], [1..8]]
        for i in number_loop
          point = [x, y + i]
          break unless highlight_cells(point)
        for i in number_loop
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
      for number_loop in [[-1..-8], [1..8]]
        for i in number_loop
          point = [x + i, y + i]
          break unless highlight_cells(point)
        for i in number_loop
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
  highlight_on_point: (point) ->
    x = point[0]
    y = point[1]
    $.cell_on_point([x, y]).addClass('highlight')
  highlight_on_point_if_possible: (point) ->
    unless $.cell_on_point_have_proponent_piece(point)
      $.highlight_on_point(point)
  board_turn: ->
    $('.board').attr('turn')
