class Game < ActiveRecord::Base

  # Room laid out as a dodecahedron

  def rooms_available(room)
    [
     [2, 5, 18], [1, 3, 20], [4, 10, 2], [3, 8, 5], [6, 4, 1],
     [5, 7, 19], [8, 14, 6], [7, 9, 4], [10, 13, 8], [9, 11, 3],
     [12, 20, 9], [11, 16, 13], [14, 12, 9], [13, 15, 7], [16, 19, 14],
     [15, 17, 12], [20, 18, 16], [19, 1, 17], [18, 6, 15], [17, 2, 11]
    ][room - 1]
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
