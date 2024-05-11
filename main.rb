require_relative 'lib/game_board'
require_relative 'lib/utilities'

include Utilities

# Manage game logic and state
class GameManager
  attr_reader :game_board, :players, :curr_player, :used_moves

  POS = {
    'TL' => [0, 0], # top left
    'TM' => [0, 2], # top middle
    'TR' => [0, 4], # top right
    'ML' => [2, 0], # ...
    'MM' => [2, 2],
    'MR' => [2, 4],
    'BL' => [4, 0],
    'BM' => [4, 2],
    'BR' => [4, 4]
  }.freeze

  def initialize
    @game_board = GameBoard.new
    @players = {
      :player1 => {:id => "", :moves => []},
      :player2 => {:id => "", :moves => []}
    }
    @used_moves = []
  end

  def prompt_start
    print 'Would you like to play a game of Tic-Tac-Toe? (y/n) '
    answer = gets.chomp.downcase
    while answer != 'y' && answer != 'n'
      print "Invalid Command: #{answer}. Please input y or n"
      answer = gets.chomp.downcase
    end
    if answer == 'n'
      puts 'Thanks for playing!'
      exit
    end
    return answer
  end

  def start_game
    init_game
    show_directives
    puts "Let's play! Player #{@players[:player1][:id]} goes first."
  end

  def show_directives
    puts 'Specify row (T, M, B) then column (L, M, R) to place your X or O. Commands:'
    puts 'TL: top-left'
    puts 'TM: top-middle'
    puts 'TR: top-right'
    puts 'ML: middle-left'
    puts 'MM: middle-middle'
    puts 'MR: middle-right'
    puts 'BL: bottom-left'
    puts 'BM: bottom-middle'
    puts 'BR: bottom-right'
  end

  def play_round
    print_board
    print "Player #{@players[@curr_player][:id]}, make your move: "
    move = gets.chomp.upcase
    msg = valid_move?(move)
    until msg == true
      puts msg
      move = gets.chomp.upcase
      msg = valid_move?(move)
    end
    @game_board.update_board(:add, @players[@curr_player][:id], POS[move])
    update_player_state(move)
    update_game_state(move)
  end

  def switch_curr_player
    @curr_player = @curr_player == :player1 ? :player2 : :player1
  end

  def report_game_result
    print_board
    puts 'Game Over. Good work.'
  end

  def print_board
    @game_board.state.each do |row|
      puts row.join
    end
  end

  def self.play_game
    game = GameManager.new
    while game.prompt_start == 'y'
      game.start_game
      9.times do
        game.play_round
        break if game_decided?(game.players[game.curr_player][:moves])

        game.switch_curr_player
      end
      game.report_game_result
    end
    puts 'Thanks for playing!'
    exit
  end

  private

  def init_game
    randomize_players
    @players[:player1][:moves].clear
    @players[:player2][:moves].clear
    @curr_player = :player1
    @game_board.update_board(:reset)
    @used_moves.clear
  end

  def randomize_players
    ids = %w[X O]
    @players[:player1][:id] = ids.delete_at(rand(0..1))
    @players[:player2][:id] = ids[0]
  end

  def valid_move?(move)
    move = move.upcase
    return "Illegal Move: #{move}. Please input a valid move" unless POS.keys.include?(move)
    return "Invalid Move: #{move} is already played! Please pick and unused position." if @used_moves.include?(move)

    true
  end

  def update_player_state(move)
    # push most recent move onto current players move stack
    @players[@curr_player][:moves].push(move)
  end

  def update_game_state(move)
    # push most recent move onto game's used moves stack
    @used_moves.push(move)
  end
end

GameManager.play_game
