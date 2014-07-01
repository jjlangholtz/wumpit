class HighScore < ActiveRecord::Base
  validates :name, presence: true

  def self.order_best_scores
    HighScore.order(moves: :asc, seconds: :asc).limit(5)
  end

  def self.rank_high_scores
    scores = self.order_best_scores
    5.times do |i|
      unless scores[i] == nil
        scores[i].rank = i + 1
        scores[i].save
      end
    end
  end
end
