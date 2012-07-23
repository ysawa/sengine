###
# Game logics of Shogi
# TODO refactor: it should be implemented not $, but Shogi
###

this.Shogi = {}
Shogi = this.Shogi

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

$.extend(
  Shogi,
  {
    board_turn: ->
      $('.board').attr('turn')
    cell_on_point: (point) ->
      x = parseInt point[0]
      y = parseInt point[1]
      $(".cell[x=\"#{x}\"][y=\"#{y}\"]")
    cell_on_point_have_piece: (point) ->
      cell = Shogi.cell_on_point(point)
      if cell.find('.piece').size() >= 1
        true
      else
        false
    cell_on_point_have_opponent_piece: (point) ->
      cell = Shogi.cell_on_point(point)
      if cell.find('.piece').size() >= 1
        cell.find('.piece').attr('direction') != Shogi.board_turn()
      else
        false
    cell_on_point_have_proponent_piece: (point) ->
      cell = Shogi.cell_on_point(point)
      if cell.find('.piece').size() >= 1
        cell.find('.piece').attr('direction') == Shogi.board_turn()
      else
        false
    cell_on_column_have_proponent_fu: (column) ->
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

    highlight_for_diagonal_walk: (x, y) ->
      for i in [-1, 1]
        for j in [-1, 1]
          Shogi.highlight_on_point_if_possible([x + i, y + j])
    highlight_for_orthogonal_walk: (x, y) ->
      for i in [-1, 1]
        Shogi.highlight_on_point_if_possible([x, y + i])
        Shogi.highlight_on_point_if_possible([x + i, y])
    highlight_for_role_fu: (x, y, direction) ->
      Shogi.highlight_on_point_if_possible([x, y - 1 * direction])
    highlight_for_role_gi: (x, y, direction) ->
      Shogi.highlight_for_diagonal_walk(x, y)
      Shogi.highlight_on_point_if_possible([x, y - 1 * direction])
    highlight_for_role_hi: (x, y, direction) ->
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
    highlight_for_role_ka: (x, y, direction) ->
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
    highlight_for_role_ke: (x, y, direction) ->
      for i in [-1, 1]
        Shogi.highlight_on_point_if_possible([x + i, y - 2 * direction])
    highlight_for_role_ki: (x, y, direction) ->
      for i in [-1, 0, 1]
        Shogi.highlight_on_point_if_possible([x + i, y - 1 * direction])
      for i in [-1, 1]
        Shogi.highlight_on_point_if_possible([x + i, y])
      Shogi.highlight_on_point_if_possible([x, y + 1 * direction])
    highlight_for_role_ky: (x, y, direction) ->
      for i in [1..8]
        point = [x, y - i * direction]
        if Shogi.cell_on_point_have_proponent_piece(point)
          break
        else
          Shogi.highlight_on_point(point)
    highlight_for_role_ou: (x, y, direction) ->
      Shogi.highlight_for_diagonal_walk(x, y)
      Shogi.highlight_for_orthogonal_walk(x, y)

    highlight_on_point: (point) ->
      x = point[0]
      y = point[1]
      Shogi.cell_on_point([x, y]).addClass('highlight')
    highlight_on_point_if_possible: (point) ->
      unless Shogi.cell_on_point_have_proponent_piece(point)
        Shogi.highlight_on_point(point)

    roles: ['fu', 'gi', 'ke', 'ky', 'ka', 'hi', 'ki', 'ou', 'to', 'ng', 'nk', 'ny', 'um', 'ry', 'ou', 'ki']
    normal_roles: ['fu', 'gi', 'ke', 'ky', 'ka', 'hi']
    reversed_roles: ['to', 'ng', 'nk', 'ny', 'um', 'ry']
    special_roles: ['ou', 'ki']
    hand_roles: ['fu', 'gi', 'ke', 'ky', 'ka', 'hi', 'ki', 'ou']
  }
)
