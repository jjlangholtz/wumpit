class GamesController < ApplicationController
  before_action :set_game
  before_action :save_game

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

  def resume
    @game.room = session[:room]
    @game.player = session[:player]
    @game.bat_one = session[:bat_one]
    @game.bat_two = session[:bat_two]
    @game.pit_one = session[:pit_one]
    @game.pit_two = session[:pit_two]
    @game.wumpit = session[:wumpit]
    @game.arrow = session[:arrow]
    next_rooms
    check_senses
    room_choices
    render "move"
  end

  def move
    @game.update(player: params[:player])
    @player = @game.player || session[:player]
    @arrow = @game.arrow
    if @game.room_has_bat?(@player)
      redirect_to games_bat_path
    end
    if @game.room_has_pit?(@player)
      flash[:lose] = "You have fallen into a pit!"
      redirect_to games_lose_path
    end
    if @game.room_has_wumpit?(@player)
      flash[:lose] = "You have been eaten by the wumpit!"
      redirect_to games_lose_path
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

  def shoot_back
    @arrow = @game.arrow
    @game.update(arrow: @arrow -= 1)
    if @arrow == 0
      flash[:lose] = "You have run out of ammo!"
      redirect_to games_lose_path
    end
    @player = @game.player
    @arrow = @game.arrow
    next_rooms
    check_senses
    room_choices
    if @back_room == @game.wumpit
      redirect_to games_win_path
    else
      flash.now[:wumpit] = "The wumpit has moved rooms!"
      @game.update(wumpit: @wumpit_rooms.sample)
      if @game.room_has_wumpit?(@player)
        flash[:lose] = "The wumpit noms on your face!"
        redirect_to games_lose_path
      end
    end
  end

  def shoot_right
    @arrow = @game.arrow
    @game.update(arrow: @arrow -= 1)
    if @arrow == 0
      flash[:lose] = "You have run out of ammo!"
      redirect_to games_lose_path
    end
    @player = @game.player
    @arrow = @game.arrow
    next_rooms
    check_senses
    room_choices
    if @right_room == @game.wumpit
      redirect_to games_win_path
    else
      flash.now[:wumpit] = "The wumpit has moved rooms!"
      @game.update(wumpit: @wumpit_rooms.sample)
      if @game.room_has_wumpit?(@player)
        flash[:lose] = "The wumpit noms on your face!"
        redirect_to games_lose_path
      end
    end
  end

  def shoot_left
    @arrow = @game.arrow
    @game.update(arrow: @arrow -= 1)
    if @arrow == 0
      flash[:lose] = "You have run out of ammo!"
      redirect_to games_lose_path
    end
    @player = @game.player
    @arrow = @game.arrow
    next_rooms
    check_senses
    room_choices
    if @left_room == @game.wumpit
      redirect_to games_win_path
    else
      flash.now[:wumpit] = "The wumpit has moved rooms!"
      @game.update(wumpit: @wumpit_rooms.sample)
      if @game.room_has_wumpit?(@player)
        flash[:lose] = "The wumpit noms on your face!"
        redirect_to games_lose_path
      end
    end
  end

  def lose
  end

  def win
  end

  private

  def game_params
    params.require(:game).permit(:player)
  end

  def set_game
    @game = Game.last
  end

  def next_rooms
    @rooms = @game.rooms_available(@game.player)
    @wumpit_rooms = @game.rooms_available(@game.wumpit)
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
    @back_room = @rooms[0]
    @left_room = @rooms[1]
    @right_room = @rooms[2]
  end

  def save_game
    session[:room] = @game.room
    session[:player] = @game.player
    session[:pit_one] = @game.pit_one
    session[:pit_two] = @game.pit_two
    session[:bat_one] = @game.bat_one
    session[:bat_two] = @game.bat_two
    session[:wumpit] = @game.wumpit
    session[:arrow] = @game.arrow
  end
end
