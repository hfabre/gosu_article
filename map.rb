# map.rb
class Map

  TILE_SIZE = 16

  # La position des tuiles que l'on va utiliser dans la tileset
  WALL_POS = 18
  FLOOR_POS = 13

  HEIGHT = 360
  WIDTH = 360
  NUMBER_OF_LINE = HEIGHT / TILE_SIZE

  ZORDER = 1

  def initialize(window, tiles_path)
    @tileset = Gosu::Image.load_tiles(window, tiles_path, TILE_SIZE, TILE_SIZE, false)
    @board = generate_board
  end

  def draw

    # On parcourt le tableau case par case pour afficher les tuiles
    @board.each_with_index do |line, height|
      line.each_with_index do |tile, width|

        # On pense à multiplier par `TILE_SIZE` pour ne pas afficher
        # toutes les cases les unes sur les autres.
        @tileset[tile.position].draw(height * TILE_SIZE, width * TILE_SIZE, ZORDER)
      end
    end
  end

  def blocked?(tile_y, tile_x)
    tile = @board[tile_y / TILE_SIZE][tile_x / TILE_SIZE]
    return true unless tile
    tile.collidable?
  end

  private

  # On génère la carte avec des murs sur les côtés
  def generate_board
    board = Array.new(NUMBER_OF_LINE, [])

    board[0] = Array.new(NUMBER_OF_LINE, Tile.new(@tileset, WALL_POS, collidable: true))
    (NUMBER_OF_LINE - 2).times do |i|
      line = []
      line << Tile.new(@tileset, WALL_POS, collidable: true)
      (NUMBER_OF_LINE - 2).times do
        line << Tile.new(@tileset, FLOOR_POS, collidable: false)
      end
      line << Tile.new(@tileset, WALL_POS, collidable: true)
      board[i + 1] = line
    end
    board[NUMBER_OF_LINE - 1] = Array.new(NUMBER_OF_LINE, Tile.new(@tileset, WALL_POS, collidable: true))
    board
  end
end