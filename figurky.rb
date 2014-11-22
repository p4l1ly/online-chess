
def strelec(position, move)
  px, py = position
  mx, my = move
  
  (mx - px).abs == (my - py).abs
end

def veza(position, move)
  px, py = position
  mx, my = move
  
  px == mx || py == my
end

def dama(position, move)
  strelec(position, move) || veza(position, move)
end

def konik(position, move)
  px, py = position
  mx, my = move

  (px - mx).abs == 1 && (py - my).abs == 2 ||
  (px - mx).abs == 2 && (py - my).abs == 1 
end