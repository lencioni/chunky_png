module ChunkyPNG
  class Canvas
    module Operations
      def compose(new_foreground, dx = 0, dy = 0)
        check_size_constraints!(new_foreground, dx, dy)

        for y in 0...new_foreground.height do
          for x in 0...new_foreground.width do
            self[x+dx, y+dy] = ChunkyPNG::Color.compose(new_foreground[x, y], self[x+dx, y+dy])
          end
        end
        self
      end

      def replace(other, offset_x = 0, offset_y = 0)
        check_size_constraints!(other, offset_x, offset_y)

        for y in 0...other.height do
          pixels[(y + offset_y) * width + offset_x, other.width] = other.pixels[y * other.width, other.width]
        end
        self
      end

      def crop(x, y, crop_width, crop_height)
        new_pixels = []
        for cy in 0...crop_height do
          new_pixels += pixels.slice((cy + y) * width + x, crop_width)
        end
        ChunkyPNG::Canvas.new(crop_width, crop_height, new_pixels)
      end

      protected

      def check_size_constraints!(other, offset_x, offset_y)
        raise "Background image width is too small!"  if width  < other.width  + offset_x
        raise "Background image height is too small!" if height < other.height + offset_y
      end
    end
  end
end
