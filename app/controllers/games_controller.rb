class GamesController < ApplicationController
  before_action :set_game, except: :start
  before_action :save_game, except: :start

  def start
    available_rooms = (1..20).to_a.shuffle!
    @game = Game.create(room: 20,
                        arrow: 5,
                        counter: 0,
                        timer: 1,
                        player: available_rooms.pop,
                        pit_one: available_rooms.pop,
                        pit_two: available_rooms.pop,
                        bat_one: available_rooms.pop,
                        bat_two: available_rooms.pop,
                        wumpit: available_rooms.pop)
    @high_scores = []
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
    @player = @game.player
    @arrow = @game.arrow
    if @game.room_has_bat?(@player)
      redirect_to games_bat_path
    end
    if @game.room_has_pit?(@player)
      flash[:lose] = "You have fallen into a pit! You lose!"
      redirect_to games_lose_path
    end
    if @game.room_has_wumpit?(@player)
      flash[:lose] = "You have been eaten by the wumpit! You lose!"
      redirect_to games_lose_path
    end
    next_rooms
    check_senses
    room_choices
  end

  def bat
    @game.counter -= 1
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
      flash[:lose] = "You have run out of ammo! You lose!"
      redirect_to games_lose_path
    end
    @player = @game.player
    @arrow = @game.arrow
    next_rooms
    check_senses
    room_choices
    if @back_room == @game.wumpit
      @game.timer = (Time.now - @game.created_at).to_i
      @game.save
      redirect_to games_win_path
    else
      flash.now[:wumpit] = "The wumpit has moved rooms!"
      @game.update(wumpit: @wumpit_rooms.sample)
      if @game.room_has_wumpit?(@player)
        flash[:lose] = "You startled the wumpit and he found you! You lose!"
        redirect_to games_lose_path
      end
    end
  end

  def shoot_right
    @arrow = @game.arrow
    @game.update(arrow: @arrow -= 1)
    if @arrow == 0
      flash[:lose] = "You have run out of ammo! You lose!"
      redirect_to games_lose_path
    end
    @player = @game.player
    @arrow = @game.arrow
    next_rooms
    check_senses
    room_choices
    if @right_room == @game.wumpit
      @game.timer = (Time.now - @game.created_at).to_i
      @game.save
      redirect_to games_win_path
    else
      flash.now[:wumpit] = "The wumpit has moved rooms!"
      @game.update(wumpit: @wumpit_rooms.sample)
      if @game.room_has_wumpit?(@player)
        flash[:lose] = "You startled the wumpit and he found you! You lose!"
        redirect_to games_lose_path
      end
    end
  end

  def shoot_left
    @arrow = @game.arrow
    @game.update(arrow: @arrow -= 1)
    if @arrow == 0
      flash[:lose] = "You have run out of ammo! You lose!"
      redirect_to games_lose_path
    end
    @player = @game.player
    @arrow = @game.arrow
    next_rooms
    check_senses
    room_choices
    if @left_room == @game.wumpit
      @game.timer = (Time.now - @game.created_at).to_i
      @game.save
      redirect_to games_win_path
    else
      flash.now[:wumpit] = "The wumpit has moved rooms!"
      @game.update(wumpit: @wumpit_rooms.sample)
      if @game.room_has_wumpit?(@player)
        flash[:lose] = "You startled the wumpit and he found you! You lose!"
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
    HighScore.rank_high_scores
    @high_scores = HighScore.order_best_scores
    @game.counter += 1
    hint_message = rand(7)
    case hint_message
    when 0
      flash.now[:hint] = "Click the orange grenades to kill the Wumpit!"
    when 1
      flash.now[:hint] = "Did you know Clinton Dreisbach has a pet Wumpit!"
    when 2
      flash.now[:hint] = "When you run out of grenades you lose!"
    when 
      flash.now[:hint] = "Your time and moves gauge your performance!"
    when 4
      flash.now[:hint] = "Click on any blue 'Rooms' to move your player!"
    when 5
      flash.now[:hint] = "Have questions? Check out the 'Rules'"
    when 6
      flash.now[:hint] = "There are two pits so be careful not to fall in!"
    when 7
      flash.now[:hint] = "Don't get caught by bats, they are in two rooms!"
    end
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
