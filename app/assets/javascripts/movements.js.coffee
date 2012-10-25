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

  execute: ->
    if @get('move')
      piece_selected = Shogi.piece_on_point(@get('from_point'))
    else
      piece_selected = Shogi.piece_in_hand_of_role(@get('role'))
    to_point = @get('to_point')
    if Shogi.cell_on_point_have_opponent_piece(to_point)
      piece = Shogi.piece_on_point(to_point)
      piece.attr('direction', piece_selected.attr('direction'))
      piece.removeClass('downward')
      piece.addClass('upward')
      Shogi.normalize_piece(piece)
      cell = $('<div>').addClass('cell')
      cell.append(piece)
      $('.in_hand.upward .pieces .row').append(cell)
    if piece_selected.parents('.in_hand').present()
      in_hand_cell = piece_selected.parents('.cell')
      number = piece_selected.siblings('.number')
      number_text = number.text()
      integer = parseInt(number_text.replace('x', ''))
      if integer <= 1
        number.remove()
      else
        number.text(number_text.replace("#{integer}", integer - 1))
        piece_selected = piece_selected.clone()
        in_hand_cell.prepend(piece_selected)
    cell = Shogi.cell_on_point(to_point)
    from_position = piece_selected.parents('.cell').position()
    to_position = cell.position()
    piece_selected.css(position: 'absolute', top: from_position.top, left: from_position.left)
    $('#game_page').append(piece_selected)
    piece_selected.animate(
      { top: to_position.top, left: to_position.left }, "easeInQuad", ->
        $.play_audio('put')
        piece_selected.css(position: 'static')
        cell.append(piece_selected).addClass('moved')
    )
    if @get('reverse')
      Shogi.reverse_piece(piece_selected)
    $('.in_hand .cell').each ->
      if $(@).find('.piece, .face, .number').size() == 0
        $(@).remove()

  urlRoot: ->
    game_id = @get('game_id')
    if game_id
      "/games/#{game_id}/movements"
    else
      "/movements"

class Shogi.MovementList extends Backbone.Collection
  model: Shogi.Movement

