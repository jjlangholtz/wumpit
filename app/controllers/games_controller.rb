class GamesController < ApplicationController
  before_action :set_game

  def start
    available_rooms = (1..20).to_a.shuffle!
    @game = Game.create(room: 20,
                        arrow: 5,
                        player: available_rooms.pop,
                        pit_one: available_rooms.pop,
                        pit_two: available_rooms.pop,
                        bat_one: available_rooms.pop,
                        bat_two: available_rooms.pop,
                        wumpit: available_rooms.pop)
    @player = @game.player
    @arrow = @game.arrow
    next_rooms
    check_senses
    room_choices
  end

  def move
    @game.update(player: params[:player])
    @player = @game.player
    @arrow = @game.arrow
    if @game.room_has_bat?(@player)
      redirect_to games_bat_path
    end
    next_rooms
    check_senses
    room_choices
  end

  def bat
    flash.now[:bat_move] = "Bats have carried you to a new room!"
    @game.update(player: rand(20) + 1)
    @player = @game.player
    @arrow = @game.arrow
    next_rooms
    check_senses
    room_choices
  end

  def shoot
    @arrow = @game.arrow
    @game.update(arrow: @arrow -= 1)
    @player = @game.player
    @arrow = @game.arrow
    next_rooms
    check_senses
    room_choices
  end

  private

  def game_params
    params.require(:game).permit(:player)
  end

  def set_game
    @game = Game.last
  end

  def next_rooms
    @rooms = @game.rooms_available(@player)
  end

  def check_senses
    if @rooms.include?(@game.pit_one) || @rooms.include?(@game.pit_two)
      flash.now[:pit] = "You feel a draft nearby"
    end
    if @rooms.include?(@game.bat_one) || @rooms.include?(@game.bat_two)
      flash.now[:bat] = "You hear wings flapping"
    end
    if @rooms.include?(@game.wumpit)
      flash.now[:wumpit] = "You smell a foul stench"
    end
  end

  def room_choices
    @first_room = @rooms[0]
    @second_room = @rooms[1]
    @third_room = @rooms[2]
  end
end
