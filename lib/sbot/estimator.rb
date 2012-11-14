# -*- coding: utf-8 -*-

module SBot
  class Estimator
    ALPHA = -400000
    BETA = 400000
    DEPTH = 3

    def cancel_move(board, move)
      board.cancel(move)
    end

    def choose_best_move(sente, board)
      if (sente > 0) ^ (@depth.even?)
        sign = -1
      else
        sign = 1
      end
      best_move, estimation = negamax(sente, board, @alpha, @beta, @depth, sign)
      best_move
    end

    def estimate(board)
      sente_score = gote_score = 0
      11.upto(99).each do |point|
        next if point % 10 == 0
        piece = board.get_piece(point)
        sente_score += board.sente_kikis.get_jump_kikis(point).size * 10
        gote_score += board.gote_kikis.get_jump_kikis(point).size * 10
        board.sente_hand.each_with_index do |number, role_key|
          next if !number || number == 0
          sente_score += (Piece::SCORES[role_key] * number * 1.2).to_i
        end
        board.gote_hand.each_with_index do |number, role_key|
          next if !number || number == 0
          gote_score += (Piece::SCORES[role_key] * number * 1.2).to_i
        end
        next unless piece
        if piece.sente > 0
          sente_score += piece.score
        else
          gote_score += piece.score
        end
      end
      sente_score - gote_score
    end

    def execute_move(board, move)
      board.execute(move)
    end

    def generate_valid_candidates(sente, board)
      candidates = []
      board.load_all
      oute_judgement = get_oute_judgement(sente, board)
      if oute_judgement
        candidates += generate_valid_escape_oute_candidates(sente, board, oute_judgement)
        return candidates
      end
      11.upto(99).each do |from_point|
        next if from_point % 10 == 0
        piece = board.get_piece(from_point)
        next unless piece && sente == piece.sente
        if sente > 0
          moves = Piece::SENTE_MOVES[piece.role]
        else
          moves = Piece::GOTE_MOVES[piece.role]
        end
        if piece.role == Piece::OU
          candidates += generate_valid_piece_move_ou_candidates(sente, board, from_point)
        else
          candidates += generate_valid_piece_move_candidates(sente, board, piece, from_point)
        end
        candidates += generate_valid_piece_jump_candidates(sente, board, piece, from_point)
      end
      candidates += generate_valid_piece_put_candidates(sente, board)
      candidates
    end

    # return: [ou_point, move_kikis, jump_kikis] or nil
    def get_oute_judgement(sente, board)
      if sente > 0
        role = Piece::OU
        opponent_kiki = board.gote_kikis
      else
        role = - Piece::OU
        opponent_kiki = board.sente_kikis
      end
      11.upto(99).each do |point|
        next if point % 10 == 0
        piece = board.get_piece(point)
        next unless piece && piece.value == role
        # this piece is ou
        # check if oute?
        move_kikis = opponent_kiki.get_move_kikis(point)
        jump_kikis = opponent_kiki.get_jump_kikis(point)
        if move_kikis.size > 0 || jump_kikis.size > 0
          return [point, move_kikis, jump_kikis]
        end
      end
      nil
    end

    def initialize
      @depth = DEPTH
      @alpha = ALPHA
      @beta = BETA
    end

    def negamax(sente, board, alpha, beta, depth, sign)
      if depth <= 0
        return [nil, sign * estimate(board)]
      end
      candidates = generate_valid_candidates(sente, board)
      candidates = sort_moves(sente, candidates)
      next_candidate = candidates.first
      unless next_candidate
        if sente > 0
          return [nil, @beta]
        else
          return [nil, @alpha]
        end
      end
      unless board.sente_ou
        return [nil, @beta]
      end
      unless board.gote_ou
        return [nil, @alpha]
      end
      candidates.each do |candidate|
        execute_move(board, candidate)
        estimation = - negamax(- sente, board, - beta, - alpha, depth - 1, sign)[1]
        cancel_move(board, candidate)
        if beta <= estimation
          return [candidate, estimation]
        end
        if alpha < estimation
          next_candidate = candidate
          alpha = estimation
        end
      end
      return [next_candidate, alpha]
    end

    def oute?(sente, board)
      !!get_oute_judgement(sente, board)
    end

    def sort_moves(sente, moves)
      moves.sort_by { |move| move.priority }
    end

  private

    def check_if_fu_exist(sente, board, x)
      fu_exist = false
      if sente > 0
        role = Piece::FU
      else
        role = - Piece::FU
      end
      y_offset = 0
      1.upto(9).each do |y|
        y_offset += 10
        to_point = y_offset + x
        piece = board.get_piece(to_point)
        if piece && piece.value == role
          fu_exist = true
          break
        end
      end
      fu_exist
    end

    def generate_valid_escape_oute_candidates(sente, board, oute_judgement)
      candidates = []
      ou_point = oute_judgement[0]
      move_kikis = oute_judgement[1]
      jump_kikis = oute_judgement[2]
      oute_length = move_kikis.size + jump_kikis.size
      if oute_length == 1
        candidates += generate_valid_piece_move_ou_candidates(sente, board, ou_point)
        if jump_kikis.size == 1
          candidates += generate_valid_piece_move_or_jump_to_be_aigoma_candidates(sente, board, ou_point, jump_kikis)
          candidates += generate_valid_piece_put_aigoma_candidates(sente, board, ou_point, jump_kikis)
          candidates += generate_valid_piece_take_outeing_piece_candidates(sente, board, ou_point, jump_kikis)
        else
          candidates += generate_valid_piece_take_outeing_piece_candidates(sente, board, ou_point, move_kikis)
        end
      else
        candidates += generate_valid_piece_move_ou_candidates(sente, board, ou_point)
      end
      candidates
    end

    def generate_valid_jumping_piece_reverse_or_not_candidates(sente, piece, from_point, to_point, pattern)
      candidates = []
      if piece.reversed?
        move = pattern.dup
        candidates << move
      else
        # always reverse in the enemy space
        if (sente > 0 && from_point <= 39) ||
            (sente < 0 && from_point >= 71) ||
            (sente > 0 && to_point <= 39) ||
            (sente < 0 && to_point >= 71)
          move = pattern.dup
          move.reverse = true
          candidates << move
        else
          move = pattern.dup
          candidates << move
        end
      end
      candidates
    end

    def generate_valid_moving_piece_reverse_or_not_candidates(sente, piece, from_point, to_point, pattern)
      candidates = []
      piece_role = piece.role
      if piece.reversed? ||
          piece_role == Piece::KI ||
          piece_role == Piece::OU
        move = pattern.dup
        candidates << move
      else
        if piece_role == Piece::FU &&
            ((sente > 0 && to_point <= 39) ||
                (sente < 0 && to_point >= 71))
          move = pattern.dup
          move.reverse = true
          candidates << move
        elsif piece_role == Piece::KE &&
            ((sente > 0 && to_point <= 29) ||
                (sente < 0 && to_point >= 81))
          move = pattern.dup
          move.reverse = true
          candidates << move
        elsif (sente > 0 && from_point <= 39) ||
            (sente < 0 && from_point >= 71) ||
            (sente > 0 && to_point <= 39) ||
            (sente < 0 && to_point >= 71)
          move = pattern.dup
          candidates << move
          move = pattern.dup
          move.reverse = true
          candidates << move
        else
          move = pattern.dup
          candidates << move
        end
      end
      candidates
    end

    def generate_valid_move_or_jump_to_point_candidates(sente, board, to_point)
      candidates = []
      if sente > 0
        player_kiki = board.sente_kikis
      else
        player_kiki = board.gote_kikis
      end
      pattern = Move.new
      pattern.number = board.number + 1
      pattern.put = false
      pattern.reverse = false
      pattern.sente = sente
      pattern.to_point = to_point
      player_move_kikis = player_kiki.get_move_kikis(to_point)
      player_jump_kikis = player_kiki.get_jump_kikis(to_point)
      player_move_kikis.each do |kiki|
        from_point = to_point + kiki
        from_piece = board.get_piece(from_point)
        next if from_piece.role == Piece::OU
        if sente > 0
          pin = board.sente_pins[from_point]
        else
          pin = board.gote_pins[from_point]
        end
        next if pin && (pin != kiki && pin != - kiki)
        pattern.from_point = from_point
        pattern.role = from_piece.role
        candidates += generate_valid_moving_piece_reverse_or_not_candidates(sente, from_piece, from_point, to_point, pattern)
      end
      player_jump_kikis.each do |kiki|
        from_point = to_point
        1.upto(8).each do
          from_point += kiki
          from_piece = board.get_piece(from_point)
          next unless from_piece
          if sente > 0
            pin = board.sente_pins[from_point]
          else
            pin = board.gote_pins[from_point]
          end
          next if pin && (pin != kiki && pin != - kiki)
          pattern.from_point = from_point
          pattern.role = from_piece.role
          candidates += generate_valid_jumping_piece_reverse_or_not_candidates(sente, from_piece, from_point, to_point, pattern)
          break
        end
      end

      candidates
    end

    def generate_valid_piece_jump_candidates(sente, board, piece, from_point)
      candidates = []
      piece_role = piece.role
      if sente > 0
        jumps = Piece::SENTE_JUMPS[piece_role]
        pin = board.sente_pins[from_point]
      else
        jumps = Piece::GOTE_JUMPS[piece_role]
        pin = board.gote_pins[from_point]
      end
      pattern = Move.new
      jumps.each do |jump|
        next if pin && (pin != jump && pin != - jump)
        to_point = from_point
        8.times do |i|
          to_point += jump
          break if to_point <= 10 ||
              to_point >= 100 ||
              (to_point % 10 == 0)
          to_piece = board.get_piece(to_point)
          break if to_piece && to_piece.sente == sente
          pattern.from_point = from_point
          pattern.number = board.number + 1
          pattern.put = false
          pattern.reverse = false
          pattern.role = piece_role
          pattern.sente = sente
          pattern.to_point = to_point
          if to_piece
            pattern.take_role = to_piece.role
          else
            pattern.take_role = nil
          end
          candidates += generate_valid_jumping_piece_reverse_or_not_candidates(sente, piece, from_point, to_point, pattern)
          break if to_piece && to_piece.sente != sente
        end
      end
      candidates
    end

    def generate_valid_piece_move_candidates(sente, board, piece, from_point)
      candidates = []
      piece_role = piece.role
      if sente > 0
        moves = Piece::SENTE_MOVES[piece_role]
        pin = board.sente_pins[from_point]
      else
        moves = Piece::GOTE_MOVES[piece_role]
        pin = board.gote_pins[from_point]
      end
      pattern = Move.new
      moves.each do |move|
        next if pin && (pin != move && pin != - move)
        to_point = from_point + move
        next if to_point <= 10 ||
            to_point >= 100 ||
            (to_point % 10 == 0)
        to_piece = board.get_piece(to_point)
        next if to_piece && to_piece.sente == sente
        pattern.from_point = from_point
        pattern.number = board.number + 1
        pattern.put = false
        pattern.reverse = false
        pattern.role = piece_role
        pattern.sente = sente
        pattern.to_point = to_point
        if to_piece
          pattern.take_role = to_piece.role
        else
          pattern.take_role = nil
        end
        candidates += generate_valid_moving_piece_reverse_or_not_candidates(sente, piece, from_point, to_point, pattern)
      end
      candidates
    end

    def generate_valid_piece_move_ou_candidates(sente, board, from_point)
      candidates = []
      moves = Piece::SENTE_MOVES[Piece::OU]
      if sente > 0
        opponent_kiki = board.gote_kikis
      else
        opponent_kiki = board.sente_kikis
      end
      opponent_jump_kikis = opponent_kiki.get_jump_kikis(from_point)
      pattern = Move.new
      pattern.from_point = from_point
      pattern.number = board.number + 1
      pattern.put = false
      pattern.reverse = false
      pattern.role = Piece::OU
      pattern.sente = sente
      moves.each do |move|
        to_point = from_point + move
        next if to_point <= 10 ||
            to_point >= 100 ||
            (to_point % 10 == 0)
        next if opponent_jump_kikis.size > 0 &&
            opponent_jump_kikis.include?(- move)
        to_piece = board.get_piece(to_point)
        next if to_piece && to_piece.sente == sente
        next if opponent_kiki.get_move_kikis(to_point).size > 0 ||
            opponent_kiki.get_jump_kikis(to_point).size > 0
        pattern.to_point = to_point
        if to_piece
          pattern.take_role = to_piece.role
        else
          pattern.take_role = nil
        end
        move = pattern.dup
        candidates << move
      end
      candidates
    end

    def generate_valid_piece_move_or_jump_to_be_aigoma_candidates(sente, board, ou_point, jump_kikis)
      candidates = []
      jump_kikis.each do |kiki|
        to_point = ou_point
        1.upto(8).each do
          to_point += kiki
          piece = board.get_piece(to_point)
          break if piece
          candidates += generate_valid_move_or_jump_to_point_candidates(sente, board, to_point)
        end
      end
      candidates
    end

    def generate_valid_piece_put_candidates(sente, board)
      candidates = []
      if sente > 0
        hand = board.sente_hand
      else
        hand = board.gote_hand
      end
      pattern = Move.new
      pattern.number = board.number + 1
      pattern.put = true
      pattern.reverse = false
      pattern.sente = sente
      hand.each_with_index do |number, role_key|
        next if !number || number == 0
        if role_key == Piece::FU
          candidates += generate_valid_piece_put_fu_candidates(sente, board, pattern)
          next
        end
        y_range = get_y_range_of_role(sente, role_key)
        pattern.role = role_key
        y_range.each do |y|
          y_offset = y * 10
          1.upto(9).each do |x|
            to_point = y_offset + x
            piece = board.get_piece(to_point)
            next if piece
            move = pattern.dup
            move.to_point = to_point
            candidates << move
          end
        end
      end
      candidates
    end

    def generate_valid_piece_put_fu_candidates(sente, board, pattern)
      candidates = []
      pattern.role = Piece::FU
      if sente > 0
        y_range = (2..9)
        role = Piece::FU
      else
        y_range = (1..8)
        role = - Piece::FU
      end
      1.upto(9).each do |x|
        fu_exist = false
        points = []
        y_offset = 0
        1.upto(9).each do |y|
          y_offset += 10
          to_point = y_offset + x
          piece = board.get_piece(to_point)
          if !piece
            points << to_point
          elsif piece.value == role
            fu_exist = true
            break
          end
        end
        next if fu_exist
        points.each do |to_point|
          next unless y_range.include?(to_point / 10)
          move = pattern.dup
          move.to_point = to_point
          candidates << move
        end
      end
      candidates
    end

    def generate_valid_piece_put_aigoma_candidates(sente, board, ou_point, jump_kikis)
      candidates = []
      if sente > 0
        hand = board.sente_hand.to_a
      else
        hand = board.gote_hand.to_a
      end
      pattern = Move.new
      pattern.number = board.number + 1
      pattern.put = true
      pattern.reverse = false
      pattern.sente = sente
      hand.each_with_index do |number, role_key|
        next if !number || number == 0
        pattern.role = role_key
        y_range = get_y_range_of_role(sente, role_key)
        jump_kikis.each do |kiki|
          to_point = ou_point
          1.upto(8).each do
            to_point += kiki
            break if Board.out_of_board?(to_point)
            if role_key == Piece::FU && check_if_fu_exist(sente, board, to_point % 10)
              next
            end
            next unless y_range.include?(to_point / 10)
            piece = board.get_piece(to_point)
            if piece
              break
            end
            move = pattern.dup
            move.to_point = to_point
            candidates << move
          end
        end
      end
      candidates
    end

    def generate_valid_piece_take_outeing_piece_candidates(sente, board, ou_point, jump_kikis)
      candidates = []
      pattern = Move.new
      pattern.number = board.number + 1
      pattern.put = false
      pattern.reverse = false
      pattern.sente = sente
      if sente > 0
        player_kiki = board.sente_kikis
      else
        player_kiki = board.gote_kikis
      end
      to_point = ou_point
      jump_kikis.each do |kiki|
        to_point += kiki
        piece = board.get_piece(to_point)
        next unless piece
        pattern.to_point = to_point
        pattern.take_role = piece.role
        # take this piece
        move_kikis = player_kiki.get_move_kikis(to_point)
        jump_kikis = player_kiki.get_jump_kikis(to_point)
        move_kikis.each do |move|
          from_point = to_point + move
          from_piece = board.get_piece(from_point)
          next if from_piece.role == Piece::OU
          if sente > 0
            pin = board.sente_pins[from_point]
          else
            pin = board.gote_pins[from_point]
          end
          next if pin && (pin != move && pin != - move)
          pattern.role = from_piece.role
          pattern.from_point = from_point
          candidates += generate_valid_moving_piece_reverse_or_not_candidates(sente, piece, from_point, to_point, pattern)
        end
        jump_kikis.each do |jump|
          from_point = to_point
          1.upto(8).each do
            from_point += jump
            from_piece = board.get_piece(from_point)
            next unless from_piece
            if sente > 0
              pin = board.sente_pins[from_point]
            else
              pin = board.gote_pins[from_point]
            end
            next if pin && (pin != jump && pin != - jump)
            pattern.role = from_piece.role
            pattern.from_point = from_point
            candidates += generate_valid_jumping_piece_reverse_or_not_candidates(sente, piece, from_point, to_point, pattern)
            break
          end
        end
        break
      end
      candidates
    end

    def get_y_range_of_role(sente, role)
      case role
      when Piece::FU, Piece::KY
        if sente > 0
          (2..9)
        else
          (1..8)
        end
      when Piece::KE
        if sente > 0
          (3..9)
        else
          (1..7)
        end
      else
        (1..9)
      end
    end
  end
end
