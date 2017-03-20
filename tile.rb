# tile.rb
class Tile
  attr_reader :position

  def initialize(tileset, tile_pos, collidable: false)
    @image = tileset[tile_pos]
    @position = tile_pos
    @collidable = collidable
  end

  def collidable?
    @collidable
  end
end
