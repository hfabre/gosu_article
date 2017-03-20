# character.rb
class Character
  SPRITE_SIZE = 16
  ZORDER = 2
  ANIMATION_NB = 4
  FRAME_DELAY = 90 # ms
  SPEED = 1.5

  # window est notre classe principale qui hérite de Gosu::Window
  # sprite_path est le chemin vers la sprite sheet
  def initialize(window, sprite_path)
    @sprite = load_sprite_from_image(window, sprite_path)
    @facing = :down
    @image_count = 0
    @x = @y = Map::HEIGHT / 2
  end

  def update(direction, map)
    unless direction.empty?
      case direction
        when :left
          @x -= SPEED unless map.blocked?(@y, @x - SPEED)
        when :right
          # Ici on rajoute SPRITE_SIZE,
          # pour tenir compte du sprite entier (largeur et hauteur),
          # et pas seulement de son origine.
          @x += SPEED unless map.blocked?(@y, @x + SPEED + SPRITE_SIZE)
        when :up
          @y -= SPEED unless map.blocked?(@y - SPEED, @x)
        when :down
          @y += SPEED unless map.blocked?(@y + SPEED + SPRITE_SIZE, @x)
      end

      @facing = direction
      if frame_expired?
        @image_count += 1
        @image_count = 0 if done?
      end
    end
  end

  def draw
    # Le ZOrder est une technique pour gérer les priorités d'affichage en 2D
    # (qui s'affiche par dessus qui).
    # On accède à notre hash de direction puis, pour le moment,
    # à la frame 0 de l'animation.
    return if done?
    @sprite[@facing][@image_count].draw(@x, @y, ZORDER)
  end

  private

  def done?
    @image_count == ANIMATION_NB
  end

  def frame_expired?
    # On récupère le nombre de millisecondes écoulées
    # depuis le lancement du programme
    now = Gosu.milliseconds

    @last_frame ||= now

    # On vérifie que le temps FRAME_DELAY n'est pas écoulé
    if (now - @last_frame) > FRAME_DELAY
      @last_frame = now
    else
      false
    end
  end

  def load_sprite_from_image(window, sprite_path)

    sprites = Gosu::Image.load_tiles(window, sprite_path, SPRITE_SIZE, SPRITE_SIZE, false)
    # Avec cet appel, Gosu nous renvoie un tableau d'images
    # découpées en SPRITE_SIZE * SPRITE_SIZE pixels.
    # Les images sont accessibles dans l'ordre ci-dessous:
    #
    # 0 | 1 | 2 | 3
    # --------------
    # 4 | 5 | 6 | 7
    # ...

    {left: sprites[4..7], right: sprites[12..15],
      down: sprites[0..3], up: sprites[8..11]}
    # Un simple hash avec pour clé l'orientation du personnage
    # et pour valeur, un tableau d'images avec les différentes frames
    # qui nous serviront à animer le personnage.
  end
end