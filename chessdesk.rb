def even(x)
  x % 2 == 0
end

def vypis
  desk = []

  (1..8).each do |i|
    row = []

    rozsah = if even(i)
               (1..8)
             else
               (0..7)
             end
    
    rozsah.each do |j|
      row = if even(j)
              row + [false]
            else
              row + [true]
            end
    end

    desk = desk + [row]
  end

  desk
end