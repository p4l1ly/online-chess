def bishop(position, move)
  px, py = position
  mx, my = move

  (mx - px).abs == (my - py).abs
end

def rook(position, move)
  px, py = position
  mx, my = move

  px == mx || py == my
end

def queen(position, move)
  bishop(position, move) || rook(position, move)
end

def knight(position, move)
  px, py = position
  mx, my = move

  (px - mx).abs == 1 && (py - my).abs == 2 ||
  (px - mx).abs == 2 && (py - my).abs == 1
end

def king(position, move)
  px, py = position
  mx, my = move

  [0,1].include?((mx-px).abs) && [0,1].include?((my-py).abs)
end

def pawn(position, move)
  true
end


RULES = {'rook'   => lambda{|x,y| rook(x,y)},
         'knight' => lambda{|x,y| knight(x,y)},
         'bishop' => lambda{|x,y| bishop(x,y)},
         'queen'  => lambda{|x,y| queen(x,y)},
         'king'   => lambda{|x,y| king(x,y)},
         'pawn'   => lambda{|x,y| pawn(x,y)}}

def chess_move(desk, selected, move_to)
  position = [selected.x, selected.y]
  x, y = move_to

  predicate = RULES[selected.type.type]

  if predicate.call(position, move_to)
    selected.update(x: x, y: y)
  end
end
