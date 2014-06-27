class Game < ActiveRecord::Base
  def rooms_available(room)
    case room
    when 1
      [2, 5, 18]
    when 2
      [1, 3, 20]
    when 3
      [4, 10, 2]
    when 4
      [3, 8, 5]
    when 5
      [6, 4, 1]
    when 6
      [5, 7, 19]
    when 7
      [8, 14, 6]
    when 8
      [7, 9, 4]
    when 9
      [10, 13, 8]
    when 10
      [9, 11, 3]
    when 11
      [12, 20, 9]
    when 12
      [11, 16, 13]
    when 13
      [14, 12, 9]
    when 14
      [13, 15, 7]
    when 15
      [16, 19, 14]
    when 16
      [15, 17, 12]
    when 17
      [20, 18, 16]
    when 18
      [19, 1, 17]
    when 19
      [18, 6, 15]
    when 20
      [17, 2, 11]
    end
  end

  def room_has_bat?(room)
    room == self.bat_one || room == self.bat_two
  end

  def room_has_wumpit?(room)
    room == self.wumpit
  end

  def room_has_pit?(room)
    room == self.pit_one || room == self.pit_two
  end
end
