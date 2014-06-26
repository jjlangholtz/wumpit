class Game < ActiveRecord::Base
  def rooms_available(room)
    case room
    when 1
      [2, 5, 18]
    when 2
      [1, 3, 20]
    when 3
      [2, 4, 10]
    when 4
      [3, 5, 8]
    when 5
      [1, 4, 6]
    when 6
      [5, 7, 19]
    when 7
      [6, 8, 14]
    when 8
      [4, 7, 9]
    when 9
      [8, 10, 13]
    when 10
      [3, 9, 11]
    when 11
      [10, 12, 20]
    when 12
      [11, 13, 16]
    when 13
      [9, 12, 14]
    when 14
      [7, 13, 15]
    when 15
      [14, 16, 19]
    when 16
      [12, 15, 17]
    when 17
      [16, 18, 20]
    when 18
      [1, 17, 19]
    when 19
      [6, 15, 18]
    when 20
      [2, 11, 17]
    end
  end
end
