class Shogi.Movement extends Backbone.Model
  defaults:
    game_id: null
    from_point: null
    number: null
    put: false
    reverse: false
    role_string: null
    sente: null
    to_point: null

  animate: (piece, animation, callback = null) ->
    piece.css(position: 'absolute')
    $(piece).animate(
      animation, 700, 'easeInCirc', ->
        $(this).css(position: 'static')
        callback() if callback
    )

  append_cell_of_piece_role: (cell, piece) ->
    piece_role = piece.attr('role')
    if piece.hasClass('downward')
      in_hand = $('.in_hand.upward .pieces .board_row')
    else
      in_hand = $('.in_hand.downward .pieces .board_row')
    roles = []
    $.each(Shogi.hand_roles, (i, role) ->
      roles.unshift(role)
    )
    previous_cell = in_hand.find('.cell:first-child')
    finished = false
    $.each(roles, (i, role) ->
      if role == piece_role
        finished = true
        return false
      target_piece = in_hand.find(".cell .piece[role=#{role}]")
      if target_piece.present()
        previous_cell = target_piece.parents('.cell')
    )
    previous_cell.after(cell)

  execute: ->
    now = @get_number()
    return if parseInt($('.board').attr('number')) == now
    $('.piece').stop(true, true) # stop all the past animations
    $('.board').attr('number', now)
    $('.cell.moved').removeClass('moved')
    if @get_put()
      if @get_sente()
        piece_selected = Shogi.Board.piece_in_hand_of_role('sente', @get_role_string())
      else
        piece_selected = Shogi.Board.piece_in_hand_of_role('gote', @get_role_string())
    else
      piece_selected = Shogi.Board.piece_on_point(@get_from_point())
    to_point = @get_to_point()
    if Shogi.Board.cell_on_point_have_opponent_piece(to_point)
      @take_piece_on_point(to_point)
    if piece_selected.parents('.in_hand').present()
      in_hand_cell = piece_selected.parents('.cell')
      number = piece_selected.siblings('.number')
      integer = @plus_number_in_hand(number, -1)
      if integer <= 0
        number.remove()
      else
        piece_selected = piece_selected.clone()
        in_hand_cell.prepend(piece_selected)
    cell = Shogi.Board.cell_on_point(to_point)
    from_position = piece_selected.parents('.cell').position()
    to_position = cell.position()
    piece_selected.css(top: from_position.top, left: from_position.left)
    $('.board_container').append(piece_selected)
    animation = { top: to_position.top, left: to_position.left }
    @animate(
      piece_selected, animation, ->
        $.play_audio('put')
        cell.append(piece_selected).addClass('moved')
    )
    if @get_reverse()
      Shogi.reverse_piece(piece_selected)
    $('.in_hand .cell').each ->
      if $(@).find('.piece, .face, .number').size() == 0
        $(@).remove()
  get_from_point: ->
    @get('from_point')
  get_game_id: ->
    @get('game_id')
  get_number: ->
    @get('number')
  get_put: ->
    @get('put')
  get_reverse: ->
    @get('reverse')
  get_role_string: ->
    @get('role_string')
  get_role: ->
    role = @get('role_string')
    Shogi.hand_roles.indexOf(role) + 1
  get_sente: ->
    @get('sente')
  get_to_point: ->
    @get('to_point')

  idAttribute: "_id"

  initialize: (attributes) ->
    return unless attributes
    from_point = attributes['from_point']
    switch $.type from_point
      when 'object'
        from_point = [from_point.x, from_point.y]
    attributes['from_point'] = from_point
    to_point = attributes['to_point']
    switch $.type to_point
      when 'object'
        to_point = [to_point.x, to_point.y]
    attributes['to_point'] = to_point
    @attributes = attributes

  piece_player: (sente) ->
    if sente
      'sente'
    else
      'gote'

  plus_number_in_hand: (number, diff) ->
    number_text = number.text()
    integer = parseInt(number_text.replace('x', ''))
    number.text(number_text.replace("#{integer}", integer + diff))
    integer + diff

  set_role: (role) ->
    role_string = Shogi.hand_roles.indexOf(role) + 1
    @set('role_string', role_string)

  set_role_string: (role) ->
    @set('role_string', role)

  take_piece_on_point: (to_point) ->
    piece = Shogi.Board.piece_on_point(to_point)
    player = @piece_player(@get('sente'))
    piece.attr('player', player)
    Shogi.normalize_piece(piece)
    piece_in_hand = Shogi.Board.piece_in_hand_of_role(player, piece.attr('role'))
    if piece_in_hand.present()
      cell = piece_in_hand.parents('.cell')
      number = cell.children('.number')
    else
      cell = $('<div>').addClass('cell')
      number = $('<div>').addClass('number').text('x 0')
      cell.append(number)
      @append_cell_of_piece_role(cell, piece)
    position = piece.position()
    piece.css(top: position.top, left: position.left)
    me = @
    cell_position = cell.position()
    animation = {
      top: cell_position.top
      left: cell_position.left
      rotate: '180deg'
    }
    @animate(
      piece, animation, ->
        piece.css('transform': 'none')
        if piece.hasClass('upward')
          piece.removeClass('upward')
          piece.addClass('downward')
        else
          piece.removeClass('downward')
          piece.addClass('upward')
        cell.prepend(piece)
        me.plus_number_in_hand(cell.children('.number'), 1)
        cell.children('.piece:gt(0)').remove()
    )

  toJSON: ->
    {
      movement: _.clone(@attributes)
    }

  urlRoot: ->
    game_id = @get_game_id()
    if game_id
      "/games/#{game_id}/movements"
    else
      "/movements"

class Shogi.MovementList extends Backbone.Collection
  model: Shogi.Movement

