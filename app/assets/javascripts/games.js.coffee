$ ->
  initialize_game = ->
    setInterval(
      ->
        if $('.board[reload]').present()
          game_number = $('.board').attr('number')
          game_id = $('.board').attr('game_id')
          $.get(
            "/games/#{game_id}/check_update",
            number: game_number
          )
      , 1000
    )
    $.initialize_audio('put')

    $('#play_buttons a').live 'ajax:beforeSend', ->
      if $(this).hasClass 'processing'
        false
      else
        $(this).addClass 'processing'
        null

    # TODO check if the selector always works (this code is very stinky)
    game_id = $('.board').attr('game_id')
    $('.board, .in_hand').disableSelection()

    # select piece on the board
    $('.board .piece.upward.playable').live 'click', ->
      unless $(this).attr('direction') == Shogi.board_turn()
        return
      $('.cell').removeClass('highlight')
      if $(this).hasClass('selected')
        $('.cell').removeClass('selected')
        $('.piece').removeClass('selected')
      else
        $('.cell').removeClass('selected')
        $('.piece').removeClass('selected')
        $(this).highlight_orbit()
        $(this).addClass('selected')
        $(this).parents('.cell').addClass('selected')

    highlight_available_cells = (role, direction) ->
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

    # select piece in self hand
    $('.in_hand .piece.upward.playable').live 'click', ->
      unless $(this).attr('direction') == $.board_turn()
        return
      $('.cell').removeClass('highlight')
      if $(this).hasClass('selected')
        $('.cell').removeClass('selected')
        $('.piece').removeClass('selected')
      else
        $('.piece').removeClass('selected')
        $(this).addClass('selected')
        $(this).parents('.cell').addClass('selected')
        role = $(this).attr('role')
        direction = $(this).attr('direction')
        highlight_available_cells(role, direction)

    select_reverse_or_not = (role, from_point, to_point, direction) ->
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

    send_movement_to_server = (game_id, role, move, from_point, to_point, reverse, direction) ->
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

    # move selected piece
    $('.cell.highlight').live 'click', ->
      $.play_audio('put')

      # initialize movement
      move = true
      piece_selected = $('.piece.selected')
      role = piece_selected.attr('role')
      direction = piece_selected.attr('direction')
      reverse = false
      if piece_selected.parents('.in_hand').size() >= 1
        move = false
      piece_cell = piece_selected.parents('.cell')
      from_point = null
      if move
        from_point = [piece_cell.point_x(), piece_cell.point_y()]
      to_point = [$(this).point_x(), $(this).point_y()]
      if move
        reverse = select_reverse_or_not(role, from_point, to_point, direction)

      # movement will be executed below
      $('.cell').removeClass('highlight')
      $('.cell').removeClass('selected')
      piece_selected.removeClass('selected')
      game_id = $('.board').attr('game_id')
      send_movement_to_server(game_id, role, move, from_point, to_point, reverse, direction)

      if Shogi.cell_on_point_have_opponent_piece(to_point)
        piece = Shogi.cell_on_point(to_point).find('.piece')
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
        if $(this).find('.piece, .face, .number').size() == 0
          $(this).remove()
      turn = $('.board').attr('turn')
      if turn == 'sente'
        $('.board').attr('turn', 'gote')
      else
        $('.board').attr('turn', 'sente')
  initialize_game()

