require 'sinatra'
require 'sinatra/reloader'
require './chessdesk'
require 'data_mapper'
require 'pry'

DataMapper.setup(:default, ENV['DATABASE_URL'] ||
                           "sqlite3://#{Dir.pwd}/chess.db")

class Piece
  include DataMapper::Resource
  
  property :id, Serial
  property :x, Integer
  property :y, Integer
  
  belongs_to :type
end


class Type
  include DataMapper::Resource
  
  property :id, Serial
  property :type, String
  property :colour, String
  property :path, String
  
  has n, :pieces
end

DataMapper.finalize

def chess_init
  Piece.all.each do |piece|
    piece.destroy
  end
  
  Piece.create(
    x:    3,
    y:    7,
    type: Type.first(colour: "white", type: "queen")
  )
  
  Piece.create(
    x:    0,
    y:    0,
    type: Type.first(colour: "black", type: "rook")
  )
end

def types_init
  Type.all.each do |type|
    type.destroy
  end
  
  Type.create(
    colour: "white",
    type:   "queen",
    path:   "pieces/queen_white.png"
  )
  
  Type.create(
    colour: "black",
    type:   "rook",
    path:   "pieces/rook_black.png"
  )
end


get '/' do
  pieces = Piece.all.to_a
  erb(:'index.html', locals: {pieces: pieces,
                              selected: nil,
                              miss: false})
end

post '/' do
  pieces = Piece.all.to_a
  x = params['cell'][0].to_i
  y = params['cell'][2].to_i
  
  piece = nil
  pieces.each do |p|
    if p.x == x and p.y == y
      piece = p
    end
  end
  
  erb(:'index.html', locals: {pieces: pieces,
                              selected: piece,
                              miss: piece == nil})
end

post '/:id' do
  moved = Piece.get(params[:id].to_i)
  x = params['cell'][0].to_i
  y = params['cell'][2].to_i
  
  moved.update(:x => x, :y => y)
  
  redirect to('/')
end