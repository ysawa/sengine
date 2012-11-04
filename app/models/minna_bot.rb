# -*- coding: utf-8 -*-

class MinnaBot < Bot
  @queue = :bot_serve

  attr_accessor :bot_sente
  attr_accessor :game
  attr_accessor :last_board

  def generate_kikis(board)
    sente_kikis = Kiki.new
    gote_kikis = Kiki.new
    11.upto(99).each do |from_value|
      next if from_value % 10 == 0
      from_point = Point.new(from_value)
      piece = board.get_piece(from_point)
      next unless piece
      piece_sente = piece.sente?
      piece.moves.each do |move|
        to_value = from_value + move
        next if to_value % 10 == 0 ||
            to_value <= 10 ||
            to_value >= 100
        if piece_sente
          sente_kikis.append_move(to_value, - move)
        else
          gote_kikis.append_move(to_value, - move)
        end
      end
      piece.jumps.each do |jump|
        to_value = from_value
        1.upto(8).each do |i|
          to_value += jump
          next if to_value % 10 == 0 ||
              to_value <= 10 ||
              to_value >= 100
          if piece_sente
            sente_kikis.append_jump(to_value, - jump)
          else
            gote_kikis.append_jump(to_value, - jump)
          end
          to_point = Point.new(to_value)
          piece = board.get_piece(to_point)
          break if piece
        end
      end
    end
    [sente_kikis, gote_kikis]
  end

  def generate_valid_candidates(player_sente, board, kikis)
    candidates = []
    oute_judgement = get_oute_judgement(player_sente, board, kikis)
    if oute_judgement
      candidates += generate_valid_escape_oute_candidates(player_sente, board, kikis, oute_judgement)
      return candidates
    end
    11.upto(99).each do |from_value|
      next if from_value % 10 == 0
      from_point = Point.new(from_value)
      piece = board.get_piece(from_point)
      next unless piece && player_sente == piece.sente?
      if player_sente
        moves = Piece::SENTE_MOVES[piece.role]
      else
        moves = Piece::GOTE_MOVES[piece.role]
      end
      if piece.role == Piece::OU
        candidates += generate_valid_piece_move_ou_candidates(player_sente, board, kikis, from_point)
      else
        candidates += generate_valid_piece_move_candidates(player_sente, board, kikis, piece, from_point)
      end
      candidates += generate_valid_piece_jump_candidates(player_sente, board, kikis, piece, from_point)
    end
    candidates += generate_valid_piece_put_candidates(player_sente, board, kikis)
    candidates
  end

  # return: [ou_point, move_kikis, jump_kikis] or nil
  def get_oute_judgement(player_sente, board, kikis)
    if player_sente
      role_value = Piece::OU
      opponent_kiki = kikis[1]
    else
      role_value = - Piece::OU
      opponent_kiki = kikis[0]
    end
    11.upto(99).each do |point_value|
      next if point_value % 10 == 0
      point = Point.new(point_value)
      piece = board.get_piece(point)
      next unless piece && piece.value == role_value
      # this piece is ou
      # check if oute?
      move_kikis = opponent_kiki.get_move_kikis(point_value)
      jump_kikis = opponent_kiki.get_jump_kikis(point_value)
      if move_kikis.size > 0 || jump_kikis.size > 0
        return [point, move_kikis, jump_kikis]
      end
    end
    nil
  end

  def oute?(player_sente, board, kikis)
    !!get_oute_judgement(player_sente, board, kikis)
  end

  def process_next_movement(game)
    @game = find_game(game)
    @bot_sente = @game.sente_user_id == id
    @last_board = @game.boards.last
    if @last_board.sente? == @bot_sente
      raise Bot::InvalidConditions.new 'turn is invalid'
    end
    kikis = generate_kikis(@last_board)
    candidates = generate_valid_candidates(@bot_sente, @last_board, kikis)
    if candidates.size == 0
      give_up!(@game)
    else
      new_movement = candidates.sample
      @game.make_board_from_movement!(new_movement)
    end
  end

  def score
    5000
  end

  def work?
    true
  end

private

  def check_if_fu_exist(player_sente, board, x)
    fu_exist = false
    1.upto(9).each do |y|
      to_point = Point.new(x, y)
      piece = board.get_piece(to_point)
      if piece && piece.value == role_value
        fu_exist = true
        break
      end
    end
    fu_exist
  end

  def generate_valid_escape_oute_candidates(player_sente, board, kikis, oute_judgement)
    candidates = []
    ou_point = oute_judgement[0]
    move_kikis = oute_judgement[1]
    jump_kikis = oute_judgement[2]
    oute_length = move_kikis.size + jump_kikis.size
    if oute_length == 1
      candidates += generate_valid_piece_move_ou_candidates(player_sente, board, kikis, ou_point)
      if jump_kikis.size == 1
        candidates += generate_valid_piece_move_or_jump_to_be_aigoma_candidates(player_sente, board, kikis, ou_point, jump_kikis)
        candidates += generate_valid_piece_put_aigoma_candidates(player_sente, board, kikis, ou_point, jump_kikis)
        candidates += generate_valid_piece_take_outeing_piece_candidates(player_sente, board, kikis, ou_point, jump_kikis)
      else
        candidates += generate_valid_piece_take_outeing_piece_candidates(player_sente, board, kikis, ou_point, move_kikis)
      end
    else
      candidates += generate_valid_piece_move_ou_candidates(player_sente, board, kikis, ou_point)
    end
    candidates
  end

  def generate_valid_jumping_piece_reverse_or_not_candidates(player_sente, piece, from_point, to_point, attributes)
    candidates = []
    if piece.reversed?
      candidates << Movement.new(attributes)
    else
      if (player_sente && to_point.y <= 2) ||
          (!player_sente && to_point.y >= 8)
        attributes[:reverse] = true
        candidates << Movement.new(attributes)
      elsif (player_sente && from_point.y <= 3) ||
          (!player_sente && from_point.y >= 7) ||
          (player_sente && to_point.y <= 3) ||
          (!player_sente && to_point.y >= 7)
        candidates << Movement.new(attributes)
        attributes[:reverse] = true
        candidates << Movement.new(attributes)
      else
        candidates << Movement.new(attributes)
      end
    end
    candidates
  end

  def generate_valid_moving_piece_reverse_or_not_candidates(player_sente, piece, from_point, to_point, attributes)
    candidates = []
    if piece.reversed? ||
        piece.role == Piece::KI ||
        piece.role == Piece::OU
      candidates << Movement.new(attributes)
    else
      if piece.role == Piece::KE &&
          ((player_sente && to_point.y <= 2) ||
              (!player_sente && to_point.y >= 8))
        attributes[:reverse] = true
        candidates << Movement.new(attributes)
        elsif (player_sente && from_point.y <= 3) ||
            (!player_sente && from_point.y >= 7) ||
            (player_sente && to_point.y <= 3) ||
            (!player_sente && to_point.y >= 7)
        candidates << Movement.new(attributes)
        attributes[:reverse] = true
        candidates << Movement.new(attributes)
      else
        candidates << Movement.new(attributes)
      end
    end
    candidates
  end

  def generate_valid_move_or_jump_to_point_candidates(player_sente, board, kikis, to_point)
    candidates = []
    to_value = to_point.x * 10 + to_point.y
    if player_sente
      player_kiki = kikis[0]
    else
      player_kiki = kikis[1]
    end
    attributes = {
      number: board.number + 1,
      put: false,
      reverse: false,
      sente: player_sente,
      to_point: to_point
    }
    player_move_kikis = player_kiki.get_move_kikis(to_value)
    player_jump_kikis = player_kiki.get_jump_kikis(to_value)
    player_move_kikis.each do |kiki|
      from_value = to_value + kiki
      from_point = Point.new(from_value)
      from_piece = board.get_piece(from_point)
      next if from_piece.role == Piece::OU
      attributes[:from_point] = from_point
      attributes[:role_value] = from_piece.role
      candidates += generate_valid_moving_piece_reverse_or_not_candidates(player_sente, from_piece, from_point, to_point, attributes)
    end
    player_jump_kikis.each do |kiki|
      from_value = to_value
      1.upto(8).each do
        from_value += kiki
        from_point = Point.new(from_value)
        from_piece = board.get_piece(from_point)
        next unless from_piece
        attributes[:from_point] = from_point
        attributes[:role_value] = from_piece.role
        candidates += generate_valid_jumping_piece_reverse_or_not_candidates(player_sente, from_piece, from_point, to_point, attributes)
        break
      end
    end

    candidates
  end

  def generate_valid_piece_jump_candidates(player_sente, board, kikis, piece, from_point)
    candidates = []
    from_value = from_point.x * 10 + from_point.y
    if player_sente
      jumps = Piece::SENTE_JUMPS[piece.role]
    else
      jumps = Piece::GOTE_JUMPS[piece.role]
    end
    jumps.each do |jump|
      to_value = from_value
      8.times do |i|
        to_value += jump
        break if to_value <= 10 ||
            to_value >= 100 ||
            (to_value % 10 == 0)
        to_point = Point.new(to_value)
        to_piece = board.get_piece(to_point)
        break if to_piece && to_piece.sente? == player_sente
        attributes = {
          from_point: from_point,
          number: board.number + 1,
          put: false,
          reverse: false,
          role_value: piece.role,
          sente: player_sente,
          to_point: to_point
        }
        candidates += generate_valid_jumping_piece_reverse_or_not_candidates(player_sente, piece, from_point, to_point, attributes)
        break if to_piece && to_piece.sente? != player_sente
      end
    end
    candidates
  end

  def generate_valid_piece_move_candidates(player_sente, board, kikis, piece, from_point)
    candidates = []
    from_value = from_point.x * 10 + from_point.y
    if player_sente
      moves = Piece::SENTE_MOVES[piece.role]
    else
      moves = Piece::GOTE_MOVES[piece.role]
    end
    moves.each do |move|
      to_value = from_value + move
      next if to_value <= 10 ||
          to_value >= 100 ||
          (to_value % 10 == 0)
      to_point = Point.new(to_value)
      to_piece = board.get_piece(to_point)
      next if to_piece && to_piece.sente? == player_sente
      attributes = {
        from_point: from_point,
        number: board.number + 1,
        put: false,
        reverse: false,
        role_value: piece.role,
        sente: player_sente,
        to_point: to_point
      }
      candidates += generate_valid_moving_piece_reverse_or_not_candidates(player_sente, piece, from_point, to_point, attributes)
    end
    candidates
  end

  def generate_valid_piece_move_ou_candidates(player_sente, board, kikis, from_point)
    candidates = []
    from_value = from_point.x * 10 + from_point.y
    moves = Piece::SENTE_MOVES[Piece::OU]
    if player_sente
      opponent_kiki = kikis[1]
    else
      opponent_kiki = kikis[0]
    end
    opponent_jump_kikis = opponent_kiki.get_jump_kikis(from_value)
    attributes = {
      from_point: from_point,
      number: board.number + 1,
      put: false,
      reverse: false,
      role_value: Piece::OU,
      sente: player_sente,
    }
    moves.each do |move|
      to_value = from_value + move
      next if to_value <= 10 ||
          to_value >= 100 ||
          (to_value % 10 == 0)
      next if opponent_jump_kikis.size > 0 &&
          opponent_jump_kikis.include?(- move)
      to_point = Point.new(to_value)
      to_piece = board.get_piece(to_point)
      next if to_piece && to_piece.sente? == player_sente
      next if opponent_kiki.get_move_kikis(to_value).size > 0 ||
          opponent_kiki.get_jump_kikis(to_value).size > 0
      attributes[:to_point] = to_point
      candidates << Movement.new(attributes)
    end
    candidates
  end

  def generate_valid_piece_move_or_jump_to_be_aigoma_candidates(player_sente, board, kikis, ou_point, jump_kikis)
    candidates = []
    ou_value = ou_point.x * 10 + ou_point.y
    attributes = {
      number: board.number + 1,
      put: false,
      reverse: false,
      sente: player_sente
    }
    jump_kikis.each do |kiki|
      to_value = ou_value
      1.upto(8).each do
        to_value += kiki
        to_point = Point.new(to_value)
        piece = board.get_piece(to_point)
        break if piece
        attributes[:to_point] = to_point
        candidates += generate_valid_move_or_jump_to_point_candidates(player_sente, board, kikis, to_point)
      end
    end
    candidates
  end

  def generate_valid_piece_put_candidates(player_sente, board, kikis)
    candidates = []
    if player_sente
      hand = board.sente_hand.to_a
    else
      hand = board.gote_hand.to_a
    end
    attributes = {
      number: board.number + 1,
      put: true,
      reverse: false,
      sente: player_sente
    }
    hand.each_with_index do |number, role_key|
      next if !number || number == 0
      case role_key
      when Piece::FU
        candidates += generate_valid_piece_put_fu_candidates(player_sente, board, kikis, attributes)
        next
      when Piece::KY
        if player_sente
          y_start = 2
          y_end = 9
        else
          y_start = 1
          y_end = 8
        end
      when Piece::KE
        if player_sente
          y_start = 3
          y_end = 9
        else
          y_start = 1
          y_end = 7
        end
      else
        y_start = 1
        y_end = 9
      end
      attributes[:role_value] = role_key
      y_start.upto(y_end).each do |y|
        1.upto(9).each do |x|
          to_point = Point.new(x, y)
          piece = board.get_piece(to_point)
          next if piece
          attributes[:to_point] = to_point
          candidates << Movement.new(attributes)
        end
      end
    end
    candidates
  end

  def generate_valid_piece_put_fu_candidates(player_sente, board, kikis, attributes)
    candidates = []
    attributes[:role_value] = Piece::FU
    if player_sente
      y_start = 2
      y_end = 9
    else
      y_start = 1
      y_end = 8
    end
    if player_sente
      role_value = Piece::FU
    else
      role_value = - Piece::FU
    end
    1.upto(9).each do |x|
      fu_exist = false
      points = []
      1.upto(9).each do |y|
        to_point = Point.new(x, y)
        piece = board.get_piece(to_point)
        if !piece
          points << to_point
        elsif piece.value == role_value
          fu_exist = true
          break
        end
      end
      next if fu_exist
      points.each do |to_point|
        y = to_point.y
        next unless y_start <= y && y <= y_end
        attributes[:to_point] = to_point
        candidates << Movement.new(attributes)
      end
    end
    candidates
  end

  # TODO also move and be aigoma
  def generate_valid_piece_put_aigoma_candidates(player_sente, board, kikis, ou_point, jump_kikis)
    candidates = []
    ou_value = ou_point.x * 10 + ou_point.y
    if player_sente
      hand = board.sente_hand.to_a
    else
      hand = board.sente_hand.to_a
    end
    attributes = {
      number: board.number + 1,
      put: true,
      reverse: false,
      sente: player_sente
    }
    hand.each_with_index do |number, role_key|
      next if !number || number == 0
      attributes[:role_value] = role_key
      case role_key
      when Piece::FU
        if player_sente
          y_start = 2
          y_end = 9
        else
          y_start = 1
          y_end = 8
        end
      when Piece::KY
        if player_sente
          y_start = 2
          y_end = 9
        else
          y_start = 1
          y_end = 8
        end
      when Piece::KE
        if player_sente
          y_start = 3
          y_end = 9
        else
          y_start = 1
          y_end = 7
        end
      else
        y_start = 1
        y_end = 9
      end
      jump_kikis.each do |kiki|
        to_value = ou_value
        1.upto(8).each do
          to_value += kiki
          to_point = Point.new(to_value)
          if role_key == Piece::FU && check_if_fu_exist(player_sente, board, to_point.x)
            next
          end
          to_point_y = to_point.y
          unless y_start <= to_point_y && to_point_y <= y_end
            next
          end
          piece = board.get_piece(to_point)
          if piece
            break
          end
          attributes[:to_point] = to_point
          candidates << Movement.new(attributes)
        end
      end
    end
    candidates
  end

  def generate_valid_piece_take_outeing_piece_candidates(player_sente, board, kikis, ou_point, jump_kikis)
    candidates = []
    ou_value = ou_point.x * 10 + ou_point.y
    attributes = {
      number: board.number + 1,
      put: false,
      reverse: false,
      sente: player_sente
    }
    if player_sente
      player_kiki = kikis[0]
    else
      player_kiki = kikis[1]
    end
    to_value = ou_value
    jump_kikis.each do |kiki|
      to_value += kiki
      to_point = Point.new(to_value)
      attributes[:to_point] = to_point
      piece = board.get_piece(to_point)
      next unless piece
      # take this piece
      move_kikis = player_kiki.get_move_kikis(to_value)
      jump_kikis = player_kiki.get_jump_kikis(to_value)
      move_kikis.each do |move|
        from_value = to_value + move
        from_point = Point.new(from_value)
        from_piece = board.get_piece(from_point)
        next if from_piece.role == Piece::OU
        attributes[:role_value] = from_piece.role
        attributes[:from_point] = from_point
        candidates += generate_valid_moving_piece_reverse_or_not_candidates(player_sente, piece, from_point, to_point, attributes)
      end
      jump_kikis.each do |jump|
        from_value = to_value
        1.upto(8).each do
          from_value += jump
          from_point = Point.new(from_value)
          from_piece = board.get_piece(from_point)
          next unless from_piece
          attributes[:role_value] = from_piece.role
          attributes[:from_point] = from_point
          candidates += generate_valid_jumping_piece_reverse_or_not_candidates(player_sente, piece, from_point, to_point, attributes)
          break
        end
      end
      break
    end
    candidates
  end
end
