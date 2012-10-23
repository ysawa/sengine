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
      , 2000
    )
    setInterval(
      ->
        if $('.board').present()
          game_id = $('.board').attr('game_id')
          after = $('.comment:first time').attr('datetime')
          except_ids = []
          $('.comment').each ->
            except_ids.push($(this).attr('comment-id'))
          if after
            $.get(
              "/games/#{game_id}/comments/check_update",
              after: after
              except_ids: except_ids
            )
      , 20000
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
        Shogi.highlight_orbit_of_piece($(this))
        $(this).addClass('selected')
        $(this).parents('.cell').addClass('selected')

    # user's selection of piece in his or her hand
    $('.in_hand .piece.upward.playable').live 'click', ->
      unless $(this).attr('direction') == Shogi.board_turn()
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
        from_point = [Shogi.get_point_x(piece_cell), Shogi.get_point_y(piece_cell)]
      to_point = [Shogi.get_point_x($(this)), Shogi.get_point_y($(this))]
      if move
        reverse = Shogi.select_reverse_or_not(role, from_point, to_point, direction)

      # movement will be executed below
      $('.cell').removeClass('highlight')
      $('.cell').removeClass('selected')
      piece_selected.removeClass('selected')
      game_id = $('.board').attr('game_id')
      Shogi.send_movement_to_server(game_id, role, move, from_point, to_point, reverse, direction)

      Shogi.execute_movement_on_board(piece_selected, to_point, reverse)

      Shogi.flip_turn()
  initialize_game()
