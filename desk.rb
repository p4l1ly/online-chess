def desk
  inf_desk = [[1,0], [0,1]].map{|x| x.cycle}.cycle
  inf_desk.take(8).map{|x| x.take(8)}
end