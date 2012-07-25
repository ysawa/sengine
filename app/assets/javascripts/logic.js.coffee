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
