###
# Game logics of Shogi
###

class Shogi

  @roles: ['fu', 'gi', 'ke', 'ky', 'ka', 'hi', 'ki', 'ou', 'to', 'ng', 'nk', 'ny', 'um', 'ry', 'ou', 'ki']
  @normal_roles: ['fu', 'gi', 'ke', 'ky', 'ka', 'hi']
  @reversed_roles: ['to', 'ng', 'nk', 'ny', 'um', 'ry']
  @special_roles: ['ou', 'ki']
  @hand_roles: ['fu', 'gi', 'ke', 'ky', 'ka', 'hi', 'ki', 'ou']

  @board_turn: ->
    $('.board').attr('turn')
  @cell_on_point: (point) ->
    x = parseInt point[0]
    y = parseInt point[1]
    $(".cell[x=\"#{x}\"][y=\"#{y}\"]")
  @cell_on_point_have_piece: (point) ->
    cell = Shogi.cell_on_point(point)
    if cell.find('.piece').size() >= 1
      true
    else
      false
  @cell_on_point_have_opponent_piece: (point) ->
    cell = Shogi.cell_on_point(point)
    if cell.find('.piece').size() >= 1
      cell.find('.piece').attr('direction') != Shogi.board_turn()
    else
      false
  @cell_on_point_have_proponent_piece: (point) ->
    cell = Shogi.cell_on_point(point)
    if cell.find('.piece').size() >= 1
      cell.find('.piece').attr('direction') == Shogi.board_turn()
    else
      false
  @cell_on_column_have_proponent_fu: (column) ->
    x = column
    result = false
    for y in [1..9]
      cell = @cell_on_point([x, y])
      piece = cell.find('.piece')
      if piece.size() >= 1
        if piece.attr('direction') == Shogi.board_turn() and piece.attr('role') is 'fu'
          result = true
          break
    result

  @execute_movement_on_board = (piece_selected, to_point, reverse) ->
    if Shogi.cell_on_point_have_opponent_piece(to_point)
      piece = Shogi.cell_on_point(to_point).find('.piece')
      piece.attr('direction', piece_selected.attr('direction'))
      piece.removeClass('downward')
      piece.addClass('upward')
      $('.in_hand.upward .pieces .row').append('<div class="cell"></div>')
      $('.in_hand.upward .pieces .row .cell:last').append(piece)
    Shogi.cell_on_point(to_point).append(piece_selected)
    if reverse
      reversed_role = piece_selected.attr('role')
      piece_selected.attr('role', reversed_role)
    $('.in_hand .cell').each ->
      if $(this).find('.piece, .face, .number').size() == 0
        $(this).remove()

  @flip_turn = ->
    turn = $('.board').attr('turn')
    if turn == 'sente'
      $('.board').attr('turn', 'gote')
    else
      $('.board').attr('turn', 'sente')

  @highlight_available_cells = (role, direction) ->
    first_line = 1
    last_line = 9
    if $.inArray(role, ['fu', 'ky']) >= 0
      if direction == 'gote'
        last_line = 8
      else
        first_line = 2
    else if role == 'ke'
      if direction == 'gote'
        last_line = 7
      else
        first_line = 3
    for x in [1..9]
      if role == 'fu' and Shogi.cell_on_column_have_proponent_fu(x)
        continue
      for y in [first_line..last_line]
        point = [x, y]
        unless Shogi.cell_on_point_have_piece(point)
          Shogi.highlight_on_point(point)

  @highlight_for_diagonal_walk: (x, y) ->
    for i in [-1, 1]
      for j in [-1, 1]
        Shogi.highlight_on_point_if_possible([x + i, y + j])
  @highlight_for_orthogonal_walk: (x, y) ->
    for i in [-1, 1]
      Shogi.highlight_on_point_if_possible([x, y + i])
      Shogi.highlight_on_point_if_possible([x + i, y])
  @highlight_for_role_fu: (x, y, direction) ->
    Shogi.highlight_on_point_if_possible([x, y - 1 * direction])
  @highlight_for_role_gi: (x, y, direction) ->
    Shogi.highlight_for_diagonal_walk(x, y)
    Shogi.highlight_on_point_if_possible([x, y - 1 * direction])
  @highlight_for_role_hi: (x, y, direction) ->
    highlight_cells = (point) ->
      if Shogi.cell_on_point_have_proponent_piece(point)
        false
      else if Shogi.cell_on_point_have_opponent_piece(point)
        Shogi.highlight_on_point(point)
        false
      else
        Shogi.highlight_on_point(point)
        true
    for number_loop in [[-1..-8], [1..8]]
      for i in number_loop
        point = [x, y + i]
        break unless highlight_cells(point)
      for i in number_loop
        point = [x + i, y]
        break unless highlight_cells(point)
  @highlight_for_role_ka: (x, y, direction) ->
    highlight_cells = (point) ->
      if Shogi.cell_on_point_have_proponent_piece(point)
        false
      else if Shogi.cell_on_point_have_opponent_piece(point)
        Shogi.highlight_on_point(point)
        false
      else
        Shogi.highlight_on_point(point)
        true
    for number_loop in [[-1..-8], [1..8]]
      for i in number_loop
        point = [x + i, y + i]
        break unless highlight_cells(point)
      for i in number_loop
        point = [x - i, y + i]
        break unless highlight_cells(point)
  @highlight_for_role_ke: (x, y, direction) ->
    for i in [-1, 1]
      Shogi.highlight_on_point_if_possible([x + i, y - 2 * direction])
  @highlight_for_role_ki: (x, y, direction) ->
    for i in [-1, 0, 1]
      Shogi.highlight_on_point_if_possible([x + i, y - 1 * direction])
    for i in [-1, 1]
      Shogi.highlight_on_point_if_possible([x + i, y])
    Shogi.highlight_on_point_if_possible([x, y + 1 * direction])
  @highlight_for_role_ky: (x, y, direction) ->
    for i in [1..8]
      point = [x, y - i * direction]
      if Shogi.cell_on_point_have_proponent_piece(point)
        break
      else
        Shogi.highlight_on_point(point)
  @highlight_for_role_ou: (x, y, direction) ->
    Shogi.highlight_for_diagonal_walk(x, y)
    Shogi.highlight_for_orthogonal_walk(x, y)

  @highlight_on_point: (point) ->
    x = point[0]
    y = point[1]
    Shogi.cell_on_point([x, y]).addClass('highlight')
  @highlight_on_point_if_possible: (point) ->
    unless Shogi.cell_on_point_have_proponent_piece(point)
      Shogi.highlight_on_point(point)

  @send_movement_to_server = (game_id, role, move, from_point, to_point, reverse, direction) ->
    movement =
      role: role
      move: move
      put: !move
      to_point: to_point
      reverse: reverse
      sente: direction == 'sente'
    movement.from_point = from_point if from_point
    $.ajax
      asyn: false
      type: "POST"
      url: "/games/#{game_id}/movements"
      data:
        movement: movement

this.Shogi = Shogi
