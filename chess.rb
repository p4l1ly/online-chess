require 'sinatra'
require 'sinatra/reloader'
require './chessdesk'
require './chess_move'
require 'data_mapper'

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

TYPES = ['rook', 'knight', 'bishop', 'queen',
         'king', 'bishop', 'knight', 'rook', 'pawn']

def chess_init
  Piece.all.each do |piece|
    piece.destroy
  end

  [[1, 'black'], [6, 'white']].each do |y, colour|
    (0..7).each do |x|
      Piece.create(
        x:    x,
        y:    y,
        type: Type.first(colour: colour, type: "pawn")
      )
    end
  end

  [[0, 'black'], [7, 'white']].each do |y, colour|
    TYPES.select{|x| x != 'pawn'}.each_with_index do |type, x|
      Piece.create(
        x:    x,
        y:    y,
        type: Type.first(colour: colour, type: type)
      )
    end
  end
end

def types_init
  Type.all.each do |type|
    type.destroy
  end

  TYPES.each do |type|
    ['white', 'black'].each do |colour|
      Type.create(
        colour: colour,
        type:   type,
        path:   "pieces/#{type}_#{colour}.png"
      )
    end
  end
end

def init
  DataMapper.auto_migrate!
  types_init
  chess_init
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

post '/move/:id' do
  selected = Piece.get(params[:id].to_i)
  x = params['cell'][0].to_i
  y = params['cell'][2].to_i

  desk = [[nil].cycle.take(8)].cycle.take(8)

  Piece.all.each do |p|
    desk[p.y][p.x] = p
  end

  chess_move(desk, selected, [x, y])

  redirect to('/')
end

post '/new_game' do
  chess_init

  redirect to('/')
end
