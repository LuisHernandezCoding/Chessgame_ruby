# rubocop:disable Style/SingleLineMethods
module Pieces
  def pawn_white; '♙'; end
  def pawn_black; '♟'; end
  def pawn_white_rotated; '🨎'; end
  def pawn_black_rotated; '🨔'; end
  def rook_white; '♖'; end
  def rook_black; '♜'; end
  def rook_white_rotated; '🨋'; end
  def rook_black_rotated; '🨑'; end
  def knight_white; '♘'; end
  def knight_black; '♞'; end
  def knight_white_rotated; '🨍'; end
  def knight_black_rotated; '🨓'; end
  def bishop_white; '♗'; end
  def bishop_black; '♝'; end
  def bishop_white_rotated; '🨌'; end
  def bishop_black_rotated; '🨒'; end
  def queen_white; '♕'; end
  def queen_black; '♛'; end
  def queen_white_rotated; '🨊'; end
  def queen_black_rotated; '🨐'; end
  def king_white; '♔'; end
  def king_black; '♚'; end
  def king_white_rotated; '🨉'; end
  def king_black_rotated; '🨏'; end

  # rubocop:disable Metrics/CyclomaticComplexity
  def getting_rotated_pieces(piece)
    case piece
    when pawn_white then pawn_white_rotated
    when pawn_black then pawn_black_rotated
    when rook_white then rook_white_rotated
    when rook_black then rook_black_rotated
    when knight_white then knight_white_rotated
    when knight_black then knight_black_rotated
    when bishop_white then bishop_white_rotated
    when bishop_black then bishop_black_rotated
    when queen_white then queen_white_rotated
    when queen_black then queen_black_rotated
    when king_white then king_white_rotated
    when king_black then king_black_rotated
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def white_pieces
    [pawn_white, rook_white, knight_white, bishop_white, queen_white, king_white]
  end

  def black_pieces
    [pawn_black, rook_black, knight_black, bishop_black, queen_black, king_black]
  end
end
# rubocop:enable Style/SingleLineMethods
