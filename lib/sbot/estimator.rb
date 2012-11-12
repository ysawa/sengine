# -*- coding: utf-8 -*-

module SBot
  class Estimator
    ALPHA = -400000
    BETA = 400000
    DEPTH = 2

    def cancel_move(board, move)
      board.cancel(move)
    end

    def choose_best_candidate(player_sente, board)
      if player_sente ^ (@depth.even?)
        sign = -1
      else
        sign = 1
      end
      best_candidate, estimation = negamax(player_sente, board, @alpha, @beta, @depth, sign)
      best_candidate
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
        if piece.sente?
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

    def generate_valid_candidates(player_sente, board)
      candidates = []
      board.load_all
      oute_judgement = get_oute_judgement(player_sente, board)
      if oute_judgement
        candidates += generate_valid_escape_oute_candidates(player_sente, board, oute_judgement)
        return candidates
      end
      11.upto(99).each do |from_point|
        next if from_point % 10 == 0
        piece = board.get_piece(from_point)
        next unless piece && player_sente == piece.sente?
        if player_sente
          moves = Piece::SENTE_MOVES[piece.role]
        else
          moves = Piece::GOTE_MOVES[piece.role]
        end
        if piece.role == Piece::OU
          candidates += generate_valid_piece_move_ou_candidates(player_sente, board, from_point)
        else
          candidates += generate_valid_piece_move_candidates(player_sente, board, piece, from_point)
        end
        candidates += generate_valid_piece_jump_candidates(player_sente, board, piece, from_point)
      end
      candidates += generate_valid_piece_put_candidates(player_sente, board)
      candidates
    end

    # return: [ou_point, move_kikis, jump_kikis] or nil
    def get_oute_judgement(player_sente, board)
      if player_sente
        role_value = Piece::OU
        opponent_kiki = board.gote_kikis
      else
        role_value = - Piece::OU
        opponent_kiki = board.sente_kikis
      end
      11.upto(99).each do |point|
        next if point % 10 == 0
        piece = board.get_piece(point)
        next unless piece && piece.value == role_value
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

    def negamax(player_sente, board, alpha, beta, depth, sign)
      if depth <= 0
        return [nil, sign * estimate(board)]
      end
      candidates = generate_valid_candidates(player_sente, board)
      candidates = sort_moves(player_sente, candidates)
      next_candidate = candidates.first
      unless next_candidate
        if player_sente
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
        estimation = - negamax(!player_sente, board, - beta, - alpha, depth - 1, sign)[1]
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

    def oute?(player_sente, board)
      !!get_oute_judgement(player_sente, board)
    end

    def sort_moves(player_sente, moves)
      moves.sort_by { |move| move.priority }
    end

  private

    def check_if_fu_exist(player_sente, board, x)
      fu_exist = false
      if player_sente
        role_value = Piece::FU
      else
        role_value = - Piece::FU
      end
      1.upto(9).each do |y|
        to_point = y * 10 + x
        piece = board.get_piece(to_point)
        if piece && piece.value == role_value
          fu_exist = true
          break
        end
      end
      fu_exist
    end

    def generate_valid_escape_oute_candidates(player_sente, board, oute_judgement)
      candidates = []
      ou_point = oute_judgement[0]
      move_kikis = oute_judgement[1]
      jump_kikis = oute_judgement[2]
      oute_length = move_kikis.size + jump_kikis.size
      if oute_length == 1
        candidates += generate_valid_piece_move_ou_candidates(player_sente, board, ou_point)
        if jump_kikis.size == 1
          candidates += generate_valid_piece_move_or_jump_to_be_aigoma_candidates(player_sente, board, ou_point, jump_kikis)
          candidates += generate_valid_piece_put_aigoma_candidates(player_sente, board, ou_point, jump_kikis)
          candidates += generate_valid_piece_take_outeing_piece_candidates(player_sente, board, ou_point, jump_kikis)
        else
          candidates += generate_valid_piece_take_outeing_piece_candidates(player_sente, board, ou_point, move_kikis)
        end
      else
        candidates += generate_valid_piece_move_ou_candidates(player_sente, board, ou_point)
      end
      candidates
    end

    def generate_valid_jumping_piece_reverse_or_not_candidates(player_sente, piece, from_point, to_point, attributes)
      candidates = []
      if piece.reversed?
        candidates << Move.new(attributes)
      else
        if (player_sente && to_point <= 29) ||
            (!player_sente && to_point >= 81)
          attributes[:reverse] = true
          candidates << Move.new(attributes)
        elsif (player_sente && from_point <= 39) ||
            (!player_sente && from_point >= 71) ||
            (player_sente && to_point <= 39) ||
            (!player_sente && to_point >= 71)
          candidates << Move.new(attributes)
          attributes[:reverse] = true
          candidates << Move.new(attributes)
        else
          candidates << Move.new(attributes)
        end
      end
      candidates
    end

    def generate_valid_moving_piece_reverse_or_not_candidates(player_sente, piece, from_point, to_point, attributes)
      candidates = []
      if piece.reversed? ||
          piece.role == Piece::KI ||
          piece.role == Piece::OU
        candidates << Move.new(attributes)
      else
        if piece.role == Piece::FU &&
            ((player_sente && to_point <= 39) ||
                (!player_sente && to_point >= 71))
          attributes[:reverse] = true
          candidates << Move.new(attributes)
        elsif piece.role == Piece::KE &&
            ((player_sente && to_point <= 29) ||
                (!player_sente && to_point >= 81))
          attributes[:reverse] = true
          candidates << Move.new(attributes)
        elsif (player_sente && from_point <= 39) ||
            (!player_sente && from_point >= 71) ||
            (player_sente && to_point <= 39) ||
            (!player_sente && to_point >= 71)
          candidates << Move.new(attributes)
          attributes[:reverse] = true
          candidates << Move.new(attributes)
        else
          candidates << Move.new(attributes)
        end
      end
      candidates
    end

    def generate_valid_move_or_jump_to_point_candidates(player_sente, board, to_point)
      candidates = []
      if player_sente
        player_kiki = board.sente_kikis
      else
        player_kiki = board.gote_kikis
      end
      attributes = {
        number: board.number + 1,
        put: false,
        reverse: false,
        sente: player_sente,
        to_point: to_point
      }
      player_move_kikis = player_kiki.get_move_kikis(to_point)
      player_jump_kikis = player_kiki.get_jump_kikis(to_point)
      player_move_kikis.each do |kiki|
        from_point = to_point + kiki
        from_piece = board.get_piece(from_point)
        next if from_piece.role == Piece::OU
        if player_sente
          pin = board.sente_pins[from_point]
        else
          pin = board.gote_pins[from_point]
        end
        next if pin && (pin != kiki && pin != - kiki)
        attributes[:from_point] = from_point
        attributes[:role_value] = from_piece.role
        candidates += generate_valid_moving_piece_reverse_or_not_candidates(player_sente, from_piece, from_point, to_point, attributes)
      end
      player_jump_kikis.each do |kiki|
        from_point = to_point
        1.upto(8).each do
          from_point += kiki
          from_piece = board.get_piece(from_point)
          next unless from_piece
          if player_sente
            pin = board.sente_pins[from_point]
          else
            pin = board.gote_pins[from_point]
          end
          next if pin && (pin != kiki && pin != - kiki)
          attributes[:from_point] = from_point
          attributes[:role_value] = from_piece.role
          candidates += generate_valid_jumping_piece_reverse_or_not_candidates(player_sente, from_piece, from_point, to_point, attributes)
          break
        end
      end

      candidates
    end

    def generate_valid_piece_jump_candidates(player_sente, board, piece, from_point)
      candidates = []
      if player_sente
        jumps = Piece::SENTE_JUMPS[piece.role]
        pin = board.sente_pins[from_point]
      else
        jumps = Piece::GOTE_JUMPS[piece.role]
        pin = board.gote_pins[from_point]
      end
      jumps.each do |jump|
        next if pin && (pin != jump && pin != - jump)
        to_point = from_point
        8.times do |i|
          to_point += jump
          break if to_point <= 10 ||
              to_point >= 100 ||
              (to_point % 10 == 0)
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
          attributes[:take_role_value] = to_piece.role if to_piece
          candidates += generate_valid_jumping_piece_reverse_or_not_candidates(player_sente, piece, from_point, to_point, attributes)
          break if to_piece && to_piece.sente? != player_sente
        end
      end
      candidates
    end

    def generate_valid_piece_move_candidates(player_sente, board, piece, from_point)
      candidates = []
      if player_sente
        moves = Piece::SENTE_MOVES[piece.role]
        pin = board.sente_pins[from_point]
      else
        moves = Piece::GOTE_MOVES[piece.role]
        pin = board.gote_pins[from_point]
      end
      moves.each do |move|
        next if pin && (pin != move && pin != - move)
        to_point = from_point + move
        next if to_point <= 10 ||
            to_point >= 100 ||
            (to_point % 10 == 0)
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
        attributes[:take_role_value] = to_piece.role if to_piece
        candidates += generate_valid_moving_piece_reverse_or_not_candidates(player_sente, piece, from_point, to_point, attributes)
      end
      candidates
    end

    def generate_valid_piece_move_ou_candidates(player_sente, board, from_point)
      candidates = []
      moves = Piece::SENTE_MOVES[Piece::OU]
      if player_sente
        opponent_kiki = board.gote_kikis
      else
        opponent_kiki = board.sente_kikis
      end
      opponent_jump_kikis = opponent_kiki.get_jump_kikis(from_point)
      attributes = {
        from_point: from_point,
        number: board.number + 1,
        put: false,
        reverse: false,
        role_value: Piece::OU,
        sente: player_sente,
      }
      moves.each do |move|
        to_point = from_point + move
        next if to_point <= 10 ||
            to_point >= 100 ||
            (to_point % 10 == 0)
        next if opponent_jump_kikis.size > 0 &&
            opponent_jump_kikis.include?(- move)
        to_piece = board.get_piece(to_point)
        next if to_piece && to_piece.sente? == player_sente
        next if opponent_kiki.get_move_kikis(to_point).size > 0 ||
            opponent_kiki.get_jump_kikis(to_point).size > 0
        attributes[:to_point] = to_point
        attributes[:take_role_value] = to_piece.role if to_piece
        candidates << Move.new(attributes)
      end
      candidates
    end

    def generate_valid_piece_move_or_jump_to_be_aigoma_candidates(player_sente, board, ou_point, jump_kikis)
      candidates = []
      attributes = {
        number: board.number + 1,
        put: false,
        reverse: false,
        sente: player_sente
      }
      jump_kikis.each do |kiki|
        to_point = ou_point
        1.upto(8).each do
          to_point += kiki
          piece = board.get_piece(to_point)
          break if piece
          attributes[:to_point] = to_point
          candidates += generate_valid_move_or_jump_to_point_candidates(player_sente, board, to_point)
        end
      end
      candidates
    end

    def generate_valid_piece_put_candidates(player_sente, board)
      candidates = []
      if player_sente
        hand = board.sente_hand
      else
        hand = board.gote_hand
      end
      attributes = {
        number: board.number + 1,
        put: true,
        reverse: false,
        sente: player_sente
      }
      hand.each_with_index do |number, role_key|
        next if !number || number == 0
        if role_key == Piece::FU
          candidates += generate_valid_piece_put_fu_candidates(player_sente, board, attributes)
          next
        end
        y_range = get_y_range_of_role(player_sente, role_key)
        attributes[:role_value] = role_key
        y_range.each do |y|
          1.upto(9).each do |x|
            to_point = y * 10 + x
            piece = board.get_piece(to_point)
            next if piece
            attributes[:to_point] = to_point
            candidates << Move.new(attributes)
          end
        end
      end
      candidates
    end

    def generate_valid_piece_put_fu_candidates(player_sente, board, attributes)
      candidates = []
      attributes[:role_value] = Piece::FU
      if player_sente
        y_range = (2..9)
      else
        y_range = (1..8)
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
          to_point = y * 10 + x
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
          next unless y_range.include?(to_point / 10)
          attributes[:to_point] = to_point
          candidates << Move.new(attributes)
        end
      end
      candidates
    end

    def generate_valid_piece_put_aigoma_candidates(player_sente, board, ou_point, jump_kikis)
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
        attributes[:role_value] = role_key
        y_range = get_y_range_of_role(player_sente, role_key)
        jump_kikis.each do |kiki|
          to_point = ou_point
          1.upto(8).each do
            to_point += kiki
            break if Board.out_of_board?(to_point)
            if role_key == Piece::FU && check_if_fu_exist(player_sente, board, to_point % 10)
              next
            end
            next unless y_range.include?(to_point / 10)
            piece = board.get_piece(to_point)
            if piece
              break
            end
            attributes[:to_point] = to_point
            candidates << Move.new(attributes)
          end
        end
      end
      candidates
    end

    def generate_valid_piece_take_outeing_piece_candidates(player_sente, board, ou_point, jump_kikis)
      candidates = []
      attributes = {
        number: board.number + 1,
        put: false,
        reverse: false,
        sente: player_sente
      }
      if player_sente
        player_kiki = board.sente_kikis
      else
        player_kiki = board.gote_kikis
      end
      to_point = ou_point
      jump_kikis.each do |kiki|
        to_point += kiki
        attributes[:to_point] = to_point
        piece = board.get_piece(to_point)
        next unless piece
        attributes[:take_role_value] = piece.role if piece.sente? != player_sente
        # take this piece
        move_kikis = player_kiki.get_move_kikis(to_point)
        jump_kikis = player_kiki.get_jump_kikis(to_point)
        move_kikis.each do |move|
          from_point = to_point + move
          from_piece = board.get_piece(from_point)
          next if from_piece.role == Piece::OU
          if player_sente
            pin = board.sente_pins[from_point]
          else
            pin = board.gote_pins[from_point]
          end
          next if pin && (pin != move && pin != - move)
          attributes[:role_value] = from_piece.role
          attributes[:from_point] = from_point
          candidates += generate_valid_moving_piece_reverse_or_not_candidates(player_sente, piece, from_point, to_point, attributes)
        end
        jump_kikis.each do |jump|
          from_point = to_point
          1.upto(8).each do
            from_point += jump
            from_piece = board.get_piece(from_point)
            next unless from_piece
            if player_sente
              pin = board.sente_pins[from_point]
            else
              pin = board.gote_pins[from_point]
            end
            next if pin && (pin != jump && pin != - jump)
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

    def get_y_range_of_role(player_sente, role)
      case role
      when Piece::FU, Piece::KY
        if player_sente
          (2..9)
        else
          (1..8)
        end
      when Piece::KE
        if player_sente
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