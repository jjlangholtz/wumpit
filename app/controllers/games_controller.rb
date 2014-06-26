class GamesController < ApplicationController
  def move
    @game = Game.first
    @room = @game.room
    @game.update(player: params[:player])
    @player = @game.player
    @next_rooms = @game.rooms_available(@player)
    @first_room = @next_rooms[0]
    @second_room = @next_rooms[1]
    @third_room = @next_rooms[2]
  end

  private

  def game_params
    params.require(:game).permit(:player)
  end
end
