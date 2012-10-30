$ ->
  initialize_game = ->
    reload_game_if_enabled = ->
      if $('.board[reload]').present()
        game_number = $('.board').attr('number')
        game_id = $('.board').attr('game-id')
        $.ajax(
          type: "GET"
          url: "/games/#{game_id}/check_update"
          data:
            number: game_number
          dataType: 'script'
          timeout: 10000
          complete: (xhr, status) ->
            setTimeout(reload_game_if_enabled, 2000)
        )
      else
        setTimeout(reload_game_if_enabled, 10000)
    setTimeout(reload_game_if_enabled, 2000)
    reload_comment_if_enabled = ->
      if $('.board').present()
        game_id = $('.board').attr('game-id')
        after = $('.comment:first time').attr('datetime')
        except_ids = []
        $('.comment').each ->
          except_ids.push($(this).attr('comment-id'))
        if after
          $.ajax(
            type: "GET"
            url: "/games/#{game_id}/comments/check_update"
            data:
              after: after
              except_ids: except_ids
            dataType: 'script'
            timeout: 10000
            complete: (xhr, status) ->
              setTimeout(reload_comment_if_enabled, 20000)
          )
        else
          setTimeout(reload_comment_if_enabled, 20000)
      else
        setTimeout(reload_comment_if_enabled, 20000)
    setTimeout(reload_comment_if_enabled, 20000)
    $.initialize_audio('put')

    $('#play_buttons a').live 'ajax:beforeSend', ->
      if $(this).hasClass 'processing'
        false
      else
        $(this).addClass 'processing'
        null

    $('.board .cell').live 'click', (event) ->
      if Shogi.insert_place_into_editor($(this))
        event.preventDefault()
        return false

    # TODO check if the selector always works when requesting with pjax (this code is very stinky)
    game_id = $('.board').attr('game-id')
    $('.board, .in_hand').disableSelection()

    # user's selection of piece on the board
    $('.board .piece.upward.playable').live 'click', ->
      if Shogi.insert_place_into_editor($(this))
        event.preventDefault()
        return false
      unless $(this).attr('direction') == Shogi.Board.board_turn()
        return
      $('.cell').removeClass('highlight')
      if $(this).hasClass('selected')
        $('.cell').removeClass('selected')
        $('.piece').removeClass('selected')
      else
        $('.cell').removeClass('selected')
        $('.piece').removeClass('selected')
        Shogi.Board.highlight_orbit_of_piece($(this))
        $(this).addClass('selected')
        $(this).parents('.cell').addClass('selected')

    # user's selection of piece in his or her hand
    $('.in_hand .piece.upward.playable').live 'click', ->
      unless $(this).attr('direction') == Shogi.Board.board_turn()
        return
      $('.cell').removeClass('highlight')
      if $(this).hasClass('selected')
        $('.cell').removeClass('selected')
        $('.piece').removeClass('selected')
      else
        $('.cell').removeClass('selected')
        $('.piece').removeClass('selected')
        $(this).addClass('selected')
        $(this).parents('.cell').addClass('selected')
        role = $(this).attr('role')
        direction = $(this).attr('direction')
        Shogi.Board.highlight_available_cells(role, direction)

    # move selected piece
    $('.cell.highlight').live 'click', ->
      if Shogi.insert_place_into_editor($(this))
        event.preventDefault()
        return false
      # initialize movement
      game_id = $('.board').attr('game-id')
      number = (parseInt($('.board').attr('number')) + 1)
      movement = new Shogi.Movement(
        game_id: game_id
        number: number
        sente: ($('.board').attr('turn') == 'sente')
      )
      piece_selected = $('.piece.selected')
      movement.set('role', piece_selected.attr('role'))
      direction = piece_selected.attr('direction')
      movement.set('move', piece_selected.parents('.in_hand').size() == 0)
      piece_cell = piece_selected.parents('.cell')
      movement.set('to_point', [Shogi.Board.get_point_x($(this)), Shogi.Board.get_point_y($(this))])
      if movement.get('move')
        movement.set('from_point', [Shogi.Board.get_point_x(piece_cell), Shogi.Board.get_point_y(piece_cell)])
        movement.set('reverse', Shogi.select_reverse_or_not(movement.get('role'), movement.get('from_point'), movement.get('to_point'), direction))
        movement.set('put', false)
      else
        movement.set('from_point', null)
        movement.set('reverse', false)
        movement.set('put', true)

      # movement will be executed below
      $('.cell').removeClass('highlight')
      $('.cell').removeClass('selected')
      piece_selected.removeClass('selected')
      # Shogi.Board.send_movement_to_server(game_id, role, move, from_point, to_point, reverse, direction)

      movement.execute()
      movement.save()
      Shogi.Board.flip_turn()

  initialize_game()
