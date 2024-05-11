module Utilities
  def game_decided?(player_moves)
    rows = []
    cols = []
    diag1 = []
    diag2 = []

    player_moves.each do |pos|
      rows.push(pos[0])
      cols.push(pos[1])
      diag1.push(pos) if pos.eql?('TL') || pos.eql?('MM') || pos.eql?('BR')
      diag2.push(pos) if pos.eql?('BL') || pos.eql?('MM') || pos.eql?('TR')
    end

    rows.uniq.each do |num|
      return true if rows.count(num) == 3
    end

    cols.uniq.each do |num|
      return true if cols.count(num) == 3
    end

    return true if diag1.length == 3 || diag2.length == 3

    false
  end
end
