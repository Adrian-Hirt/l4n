module TimeExt
  def round_nearest(sec = 1)
    down = self - (to_i % sec)
    up = down + sec

    difference_down = self - down
    difference_up = up - self

    if difference_down < difference_up
      down
    else
      up
    end
  end
end

class Time
  prepend ::TimeExt
end
