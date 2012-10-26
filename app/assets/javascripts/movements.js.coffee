class Shogi.Movement extends Backbone.Model
  defaults:
    game_id: null
    sente: null
    from_point: null
    move: false
    number: null
    put: false
    reverse: false
    role: null
    to_point: null

  animate: (piece, position, callback = null) ->
    piece.css(position: 'absolute')
    $(piece).animate(
      { top: position.top, left: position.left }, 700, 'easeInCirc', ->
        $(this).css(position: 'static')
        callback() if callback
    )

  execute: ->
    return if parseInt($('.board').attr('number')) == @get('number')
    $('.board').attr('number', @get('number'))
    $('.cell.moved').removeClass('moved')
    if @get('move')
      piece_selected = Shogi.Board.piece_on_point(@get('from_point'))
    else
      if @get('sente')
        piece_selected = Shogi.Board.piece_in_hand_of_role('sente', @get('role'))
      else
        piece_selected = Shogi.Board.piece_in_hand_of_role('gote', @get('role'))
    to_point = @get('to_point')
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
    $('#game_page').append(piece_selected)
    @animate(
      piece_selected, to_position, ->
        $.play_audio('put')
        cell.append(piece_selected).addClass('moved')
    )
    if @get('reverse')
      Shogi.reverse_piece(piece_selected)
    $('.in_hand .cell').each ->
      if $(@).find('.piece, .face, .number').size() == 0
        $(@).remove()

  idAttribute: "_id"

  initialize: (attributes) ->
    from_point = attributes.from_point
    switch $.type from_point
      when 'object'
        from_point = [from_point.x, from_point.y]
    attributes.from_point = from_point
    to_point = attributes.to_point
    switch $.type to_point
      when 'object'
        to_point = [to_point.x, to_point.y]
    attributes.to_point = to_point
    @attributes = attributes

  piece_direction: (sente) ->
    if sente
      'sente'
    else
      'gote'

  plus_number_in_hand: (number, diff) ->
    number_text = number.text()
    integer = parseInt(number_text.replace('x', ''))
    number.text(number_text.replace("#{integer}", integer + diff))
    integer + diff

  take_piece_on_point: (to_point) ->
    piece = Shogi.Board.piece_on_point(to_point)
    direction = @piece_direction(@get('sente'))
    piece.attr('direction', direction)
    if piece.hasClass('upward')
      piece.removeClass('upward')
      piece.addClass('downward')
    else
      piece.removeClass('downward')
      piece.addClass('upward')
    Shogi.normalize_piece(piece)
    piece_in_hand = Shogi.Board.piece_in_hand_of_role(direction, piece.attr('role'))
    if piece_in_hand.present()
      cell = piece_in_hand.parents('.cell')
      number = cell.children('.number')
    else
      cell = $('<div>').addClass('cell')
      number = $('<div>').addClass('number').text('x 0')
      cell.append(number)
    if piece.hasClass('upward')
      $('.in_hand.upward .pieces .row').append(cell)
    else
      $('.in_hand.downward .pieces .row').append(cell)
    position = piece.position()
    piece.css(top: position.top, left: position.left)
    me = @
    @animate(
      piece, cell.position(), ->
        cell.prepend(piece)
        me.plus_number_in_hand(cell.children('.number'), 1)
        cell.children('.piece:gt(0)').remove()
    )

  urlRoot: ->
    game_id = @get('game_id')
    if game_id
      "/games/#{game_id}/movements"
    else
      "/movements"

class Shogi.MovementList extends Backbone.Collection
  model: Shogi.Movement
