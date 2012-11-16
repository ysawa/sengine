# -*- coding: utf-8 -*-

module SBot
  class Piece
    # <tt>Piece</tt> generate more understandable instances from role value.
    # Role value is only an integer and we cannot find what the value means.
    # Convert role value into a Piece instance, and get some convenient methods.

    # role values
    NONE = 0
    FU = 1; KY =  2; KE =  3; GI =  4; KI = 5; KA =  6; HI =  7; OU = 8;
    TO = 9; NY = 10; NK = 11; NG = 12;       ; UM = 14; RY = 15;
    WALL = 64;
    ROLES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 14, 15]
    NORMAL_ROLES = [1, 2, 3, 4, 6, 7]
    REVERSED_ROLES = [9, 10, 11, 12, 14, 15]
    SPECIAL_ROLES = [5, 8]
    HAND_ROLES = [1, 2, 3, 4, 5, 6, 7, 8]

    SCORES = [nil, 10, 50, 55, 70, 80, 100, 120, 20000, 90, 80, 80, 80, nil, 150, 180]

    SENTE_MOVES = [
      nil,
      [-10], [], [-21, -19], [11, 9, -9, -10, -11], # FU, KY, KE, GI
      [10, 1, -1, -9, -10, -11], [], [], [-11, -10, -9, -1, 1, 9, 10, 11], # KI, KA, HI, OU
      [10, 1, -1, -9, -10, -11], [10, 1, -1, -9, -10, -11], # TO, NY
      [10, 1, -1, -9, -10, -11], [10, 1, -1, -9, -10, -11], # NK, NG
      nil, [-10, -1, 1, 10], [-11, -9, 9, 11] # nil, UM, RY
    ]
    GOTE_MOVES = [
      nil,
      [10], [], [21, 19], [11, 10, 9, -9, -11], # FU, KY, KE, GI
      [11, 10, 9, 1, -1, -10], [], [], [11, 10, 9, 1, -1, -9, -10, -11], # KI, KA, HI, OU
      [11, 10, 9, 1, -1, -10], [11, 10, 9, 1, -1, -10], # TO, NY
      [11, 10, 9, 1, -1, -10], [11, 10, 9, 1, -1, -10], # NK, NG
      nil, [10, 1, -1, -10], [11, 9, -9, -11], [], # nil, UM, RY
    ]
    SENTE_JUMPS = [
      nil,
      [], [-10], [], [], # FU, KY, KE, GI
      [], [-11, -9, 9, 11], [-10, -1, 1, 10], [], # KI, KA, HI, OU
      [], [], [], [], # TO, NY, KY, NG
      nil, [-11, -9, 9, 11], [-10, -1, 1, 10], # nil, UM, RY
    ]
    GOTE_JUMPS = [
      nil,
      [], [10], [], [], # FU, KY, KE, GI
      [], [-11, -9, 9, 11], [-10, -1, 1, 10], [], # KI, KA, HI, OU
      [], [], [], [], # TO, NY, KY, NG
      nil, [-11, -9, 9, 11], [-10, -1, 1, 10], # nil, UM, RY
    ]
    JUMP_DIRECTIONS = [-11, -10, -9, -1, 1, 9, 10, 11]
  end
end
