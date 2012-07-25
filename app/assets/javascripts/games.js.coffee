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

    # TODO check if the selector always works when requesting with pjax (this code is very stinky)
    game_id = $('.board').attr('game_id')
    $('.board, .in_hand').disableSelection()

    # user's selection of piece on the board
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

    # user's selection of piece in his or her hand
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
        Shogi.highlight_available_cells(role, direction)

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
      Shogi.send_movement_to_server(game_id, role, move, from_point, to_point, reverse, direction)

      Shogi.execute_movement_on_board(piece_selected, to_point, reverse)

      Shogi.flip_turn()
  initialize_game()

