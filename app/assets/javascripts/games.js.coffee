$ ->
  initialize_game = ->
    setInterval(
      ->
        game_number = $('.board').attr('number')
        $.get(
          "/games/#{game_id}/check_update",
          number: game_number
        )
      , 1000
    )
    $.initialize_audio('put')

    game_id = $('.board').attr('game_id')
    $('.board, .in_hand').disableSelection()
    $('.board[play] .piece.upward').live 'click', ->
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
        role = $(this).attr('role')
        direction = $(this).attr('direction')
        if $.inArray(role, ['fu', 'kyosha']) >= 0
          if direction == 'gote'
            last_line = 8
          else
            first_line = 2
        else if role == 'keima'
          if direction == 'gote'
            last_line = 7
          else
            first_line = 3
        for x in [1..9]
          if role == 'fu' and $.cell_on_column_have_proponent_fu(x)
            continue
          for y in [first_line..last_line]
            point = [x, y]
            unless $.cell_on_point_have_piece(point)
              $.highlight_on_point(point)

    $('.cell.highlight').live 'click', ->
      $.play_audio('put')
      move = true
      piece_selected = $('.piece.selected')
      role = piece_selected.attr('role')
      direction = piece_selected.attr('direction')
      reverse = false
      if piece_selected.parents('.in_hand').size() >= 1
        move = false
      piece_cell = piece_selected.parents('.cell')
      from_point = null
      to_point = [$(this).point_x(), $(this).point_y()]
      in_opponent_first_line = (direction == 'sente' and to_point[1] == 1) or (direction == 'gote' and to_point[1] == 9)
      in_opponent_second_line = (direction == 'sente' and to_point[1] == 2) or (direction == 'gote' and to_point[1] == 8)
      in_opponent_area = (direction == 'sente' and to_point[1] <= 3) or (direction == 'gote' and to_point[1] >= 7)
      if move
        from_point = [piece_cell.point_x(), piece_cell.point_y()]
        not_reversed = $.inArray(role, ['fu', 'gin', 'keima', 'kyosha', 'kaku', 'hisha']) >= 0
        if in_opponent_first_line and $.inArray(role, ['fu', 'keima', 'kyosha']) >= 0
          reverse = true
        else if in_opponent_second_line and role == 'keima'
          reverse = true
        else if not_reversed and in_opponent_area and confirm('成りますか?')
          reverse = true
      $('.cell').removeClass('highlight')
      piece_selected.removeClass('selected')
      game_id = $('.board').attr('game_id')
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
      if $.cell_on_point_have_opponent_piece(to_point)
        piece = $.cell_on_point(to_point).find('.piece')
        piece.attr('direction', piece_selected.attr('direction'))
        piece.removeClass('downward')
        piece.addClass('upward')
        $('.in_hand.upward .pieces .row').append('<div class="cell"></div>')
        $('.in_hand.upward .pieces .row .cell:last').append(piece)
      $(this).append(piece_selected)
      if reverse
        reversed_role = piece_selected.attr('role')
        piece_selected.attr('role', reversed_role)
      $('.in_hand .cell').each ->
        if $(this).find('.piece').size() == 0
          $(this).remove()
      turn = $('.board').attr('turn')
      if turn == 'sente'
        $('.board').attr('turn', 'gote')
      else
        $('.board').attr('turn', 'sente')
  if $('.board').size() == 1
    initialize_game()

