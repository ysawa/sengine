class Shogi.Board extends Backbone.Model
  defaults:
    game_id: null
    number: 0
    sente: null

  @board_turn: ->
    $('.board').attr('turn')
  @cell_have_piece: (cell) ->
    cell.find('.piece').size() > 0
  @cell_on_point: (point) ->
    x = parseInt point[0]
    y = parseInt point[1]
    $(".cell[x=\"#{x}\"][y=\"#{y}\"]")
  @cell_on_point_have_piece: (point) ->
    cell = Shogi.Board.cell_on_point(point)
    if cell.find('.piece').size() >= 1
      true
    else
      false
  @cell_on_point_have_opponent_piece: (point) ->
    cell = Shogi.Board.cell_on_point(point)
    if cell.find('.piece').size() >= 1
      cell.find('.piece').attr('direction') != Shogi.Board.board_turn()
    else
      false
  @cell_on_point_have_proponent_piece: (point) ->
    cell = Shogi.Board.cell_on_point(point)
    if cell.find('.piece').size() >= 1
      cell.find('.piece').attr('direction') == Shogi.Board.board_turn()
    else
      false
  @cell_on_column_have_proponent_fu: (column) ->
    x = column
    result = false
    for y in [1..9]
      cell = @cell_on_point([x, y])
      piece = cell.find('.piece')
      if piece.size() >= 1
        if piece.attr('direction') == Shogi.Board.board_turn() and piece.attr('role') is 'fu'
          result = true
          break
    result
  @flip_turn = (turn) ->
    unless turn
      if $('.board').attr('turn') == 'sente'
        turn = 'gote'
      else
        turn = 'sente'
    $('.board').attr('turn', turn)
    $('.cell .face').parents('.cell').toggleClass('in_turn')
  @get_point_x: (object) ->
    if object.hasClass('piece')
      parseInt object.parents('.cell').attr('x')
    else if object.hasClass('cell')
      parseInt object.attr('x')
  @get_point_y: (object) ->
    if object.hasClass('piece')
      parseInt object.parents('.cell').attr('y')
    else if object.hasClass('cell')
      parseInt object.attr('y')
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
      if role == 'fu' and Shogi.Board.cell_on_column_have_proponent_fu(x)
        continue
      for y in [first_line..last_line]
        point = [x, y]
        unless Shogi.Board.cell_on_point_have_piece(point)
          Shogi.Board.highlight_on_point(point)

  @highlight_for_diagonal_walk: (x, y) ->
    for i in [-1, 1]
      for j in [-1, 1]
        Shogi.Board.highlight_on_point_if_possible([x + i, y + j])
  @highlight_for_orthogonal_walk: (x, y) ->
    for i in [-1, 1]
      Shogi.Board.highlight_on_point_if_possible([x, y + i])
      Shogi.Board.highlight_on_point_if_possible([x + i, y])
  @highlight_for_role_fu: (x, y, direction) ->
    Shogi.Board.highlight_on_point_if_possible([x, y - 1 * direction])
  @highlight_for_role_gi: (x, y, direction) ->
    Shogi.Board.highlight_for_diagonal_walk(x, y)
    Shogi.Board.highlight_on_point_if_possible([x, y - 1 * direction])
  @highlight_for_role_hi: (x, y, direction) ->
    highlight_cells = (point) ->
      if Shogi.Board.cell_on_point_have_proponent_piece(point)
        false
      else if Shogi.Board.cell_on_point_have_opponent_piece(point)
        Shogi.Board.highlight_on_point(point)
        false
      else
        Shogi.Board.highlight_on_point(point)
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
      if Shogi.Board.cell_on_point_have_proponent_piece(point)
        false
      else if Shogi.Board.cell_on_point_have_opponent_piece(point)
        Shogi.Board.highlight_on_point(point)
        false
      else
        Shogi.Board.highlight_on_point(point)
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
      Shogi.Board.highlight_on_point_if_possible([x + i, y - 2 * direction])
  @highlight_for_role_ki: (x, y, direction) ->
    for i in [-1, 0, 1]
      Shogi.Board.highlight_on_point_if_possible([x + i, y - 1 * direction])
    for i in [-1, 1]
      Shogi.Board.highlight_on_point_if_possible([x + i, y])
    Shogi.Board.highlight_on_point_if_possible([x, y + 1 * direction])
  @highlight_for_role_ky: (x, y, direction) ->
    for i in [1..8]
      point = [x, y - i * direction]
      if Shogi.Board.cell_on_point_have_proponent_piece(point)
        break
      else
        Shogi.Board.highlight_on_point(point)
  @highlight_for_role_ou: (x, y, direction) ->
    Shogi.Board.highlight_for_diagonal_walk(x, y)
    Shogi.Board.highlight_for_orthogonal_walk(x, y)

  @highlight_on_point: (point) ->
    x = point[0]
    y = point[1]
    Shogi.Board.cell_on_point([x, y]).addClass('highlight')
  @highlight_on_point_if_possible: (point) ->
    unless Shogi.Board.cell_on_point_have_proponent_piece(point)
      Shogi.Board.highlight_on_point(point)

  @highlight_orbit_of_piece: (piece) ->
    piece = $(piece)
    x = Shogi.Board.get_point_x(piece)
    y = Shogi.Board.get_point_y(piece)
    role = piece.attr('role')
    sente = piece.attr('direction') == 'sente'
    direction = +1
    unless sente
      direction = -1
    switch role
      when 'fu'
        Shogi.Board.highlight_for_role_fu(x, y, direction)
      when 'ke'
        Shogi.Board.highlight_for_role_ke(x, y, direction)
      when 'ou'
        Shogi.Board.highlight_for_role_ou(x, y, direction)
      when 'gi'
        Shogi.Board.highlight_for_role_gi(x, y, direction)
      when 'ki', 'to', 'ny', 'nk', 'ng'
        Shogi.Board.highlight_for_role_ki(x, y, direction)
      when 'ky'
        Shogi.Board.highlight_for_role_ky(x, y, direction)
      when 'hi'
        Shogi.Board.highlight_for_role_hi(x, y, direction)
      when 'ry'
        Shogi.Board.highlight_for_role_hi(x, y, direction)
        Shogi.Board.highlight_for_diagonal_walk(x, y)
      when 'ka'
        Shogi.Board.highlight_for_role_ka(x, y, direction)
      when 'um'
        Shogi.Board.highlight_for_role_ka(x, y, direction)
        Shogi.Board.highlight_for_orthogonal_walk(x, y)
  @piece_in_hand_of_role: (hand, role) ->
    $(".in_hand[hand=#{hand}] .piece[role=#{role}]")
  @piece_on_point: (point) ->
    cell = Shogi.Board.cell_on_point(point)
    if cell
      cell.children('.piece')
    else
      null

