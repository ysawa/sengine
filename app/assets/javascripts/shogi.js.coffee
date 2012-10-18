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
  @cell_have_piece: (cell) ->
    cell.find('.piece').size() > 0
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
    # take opponent piece into proponent hand
    if Shogi.cell_on_point_have_opponent_piece(to_point)
      piece = Shogi.cell_on_point(to_point).find('.piece')
      piece.attr('direction', piece_selected.attr('direction'))
      piece.removeClass('downward')
      piece.addClass('upward')
      @normalize_piece(piece)
      cell = $('<div>').addClass('cell')
      cell.append(piece)
      $('.in_hand.upward .pieces .row').append(cell)
    if piece_selected.parents('.in_hand').present()
      number = piece_selected.siblings('.number')
      number_text = number.text()
      integer = parseInt(number_text.replace('x', ''))
      if integer <= 1
        piece_selected.parents('.cell').remove()
      else
        number.text(number_text.replace("#{integer}", integer - 1))
    cell = Shogi.cell_on_point(to_point)
    cell.append(piece_selected).addClass('moved')
    if reverse
      @reverse_piece(piece_selected)
    $('.in_hand .cell').each ->
      if $(this).find('.piece, .face, .number').size() == 0
        $(this).remove()

  @flip_turn = ->
    turn = $('.board').attr('turn')
    if turn == 'sente'
      $('.board').attr('turn', 'gote')
    else
      $('.board').attr('turn', 'sente')

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

  @highlight_orbit_of_piece: (piece) ->
    piece = $(piece)
    x = Shogi.get_point_x(piece)
    y = Shogi.get_point_y(piece)
    role = piece.attr('role')
    sente = piece.attr('direction') == 'sente'
    direction = +1
    unless sente
      direction = -1
    switch role
      when 'fu'
        Shogi.highlight_for_role_fu(x, y, direction)
      when 'ke'
        Shogi.highlight_for_role_ke(x, y, direction)
      when 'ou'
        Shogi.highlight_for_role_ou(x, y, direction)
      when 'gi'
        Shogi.highlight_for_role_gi(x, y, direction)
      when 'ki', 'to', 'ny', 'nk', 'ng'
        Shogi.highlight_for_role_ki(x, y, direction)
      when 'ky'
        Shogi.highlight_for_role_ky(x, y, direction)
      when 'hi'
        Shogi.highlight_for_role_hi(x, y, direction)
      when 'ry'
        Shogi.highlight_for_role_hi(x, y, direction)
        Shogi.highlight_for_diagonal_walk(x, y)
      when 'ka'
        Shogi.highlight_for_role_ka(x, y, direction)
      when 'um'
        Shogi.highlight_for_role_ka(x, y, direction)
        Shogi.highlight_for_orthogonal_walk(x, y)

  @normalize_piece = (piece) ->
    me = @
    $.each(@reversed_roles, (i, role) ->
      if piece.attr('role') == role
        piece.attr('role', role)
        piece.removeClass("role_#{role}")
        piece.addClass("role_#{me.normal_roles[i]}")
        return false
    )

  @select_reverse_or_not = (role, from_point, to_point, direction) ->
    in_opponent_first_line = (direction == 'sente' and to_point[1] == 1) or (direction == 'gote' and to_point[1] == 9)
    in_opponent_second_line = (direction == 'sente' and to_point[1] == 2) or (direction == 'gote' and to_point[1] == 8)
    in_opponent_area = (direction == 'sente' and to_point[1] <= 3) or (direction == 'gote' and to_point[1] >= 7)
    out_opponent_area = (direction == 'sente' and from_point[1] <= 3) or (direction == 'gote' and from_point[1] >= 7)
    not_reversed = $.inArray(role, ['fu', 'gi', 'ke', 'ky', 'ka', 'hi']) >= 0
    if in_opponent_first_line and $.inArray(role, ['fu', 'ke', 'ky']) >= 0
      reverse = true
    else if in_opponent_second_line and role == 'ke'
      reverse = true
    else if not_reversed and (in_opponent_area or out_opponent_area) and confirm($.i18n.t('reverse?'))
      reverse = true

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

  @reverse_piece = (piece) ->
    me = @
    $.each(@normal_roles, (i, role) ->
      if piece.attr('role') == role
        piece.attr('role', role)
        piece.removeClass("role_#{role}")
        piece.addClass("role_#{me.reversed_roles[i]}")
        return false
    )

this.Shogi = Shogi
