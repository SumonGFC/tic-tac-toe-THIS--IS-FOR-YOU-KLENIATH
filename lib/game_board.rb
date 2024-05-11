class GameBoard
  # Purpose: control the state of the gameboard display
  # API provides read-access to @state and requests to #update_board
  
  attr_reader :state

  SYM = {
    :VL => "\u2502",    # unicode vertical line
    :HL => "\u2500",    # unicode horizontal line
    :cross => "\u253c", # unicode cross
    :space => " "
  }

  INIT_STATE = [
    [SYM[:space], SYM[:VL], SYM[:space], SYM[:VL], SYM[:space]],
    [SYM[:HL], SYM[:cross] ,SYM[:HL], SYM[:cross], SYM[:HL]],
    [SYM[:space], SYM[:VL], SYM[:space], SYM[:VL], SYM[:space]],
    [SYM[:HL], SYM[:cross] ,SYM[:HL], SYM[:cross], SYM[:HL]],
    [SYM[:space], SYM[:VL], SYM[:space], SYM[:VL], SYM[:space]]
  ]

  def initialize
    reset_board()
  end
  
  def update_board(cmd=nil, player=nil, pos=nil)
    if cmd == :add
      return "Error: Invalid Position" if invalid_args?(pos, player)
      add_move(player, pos)
      return "Success: Board Updated"
    elsif cmd == :reset
      reset_board()
      return "Success: Board Reset"
    else
      return "Error: Invalid Command"
    end
  end

  private
  
  def add_move(player, pos)
    row = pos[0]
    col = pos[1]
    @state[row][col] = player
  end

  def reset_board
    @state =  INIT_STATE.map { |row| row.dup }
  end

  def invalid_args?(pos, player)
    pos.each { |i| return false if (i % 2 != 0) }
    return false if (player != "X" || player != "O")
    return true
  end
end
