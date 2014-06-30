class HighScoresController < ApplicationController
  def new
    @high_score = HighScore.new
  end

  def create
    @game = Game.last
    @high_score = HighScore.create(high_score_params)
    @high_score.update(moves: @game.counter, seconds: @game.timer )
    @high_score.save
    redirect_to games_start_path
  end

  private

  def high_score_params
    params.require(:high_score).permit(:name, :moves, :seconds)
  end
end
