# frozen_string_literal: true

require 'dotenv'
require 'chunky_png'
require 'pathname'

Dotenv.load

def simple_execute
  aspect_ratio = ENV['ASPECT_RATIO'].to_f

  filesize_width = ENV['FILESIZE_WIDTH'].to_i
  filesize_height = (filesize_width / aspect_ratio).to_i

  x_min = ENV['X_MIN'].to_f
  y_min = ENV['Y_MIN'].to_f

  space_width = ENV['SPACE_WIDTH'].to_f
  space_height = space_width / aspect_ratio

  x_max = x_min + space_width
  y_max = y_min + space_height

  max_iterations = ENV['MAX_ITERATIONS'].to_i

  output_directory = ENV['OUTPUT_DIRECTORY']
  filename = __FILE__.split('/').last.split('.').first
  output_path = Pathname.new(output_directory).join("#{filename}.png")

  # 画像の初期化
  png = ChunkyPNG::Image.new(filesize_width, filesize_height, ChunkyPNG::Color::BLACK)

  # マンデルブロ集合の計算
  (0...filesize_width).each do |x|
    (0...filesize_height).each do |y|
      # 座標の変換
      zx = x_min + (x_max - x_min) * x / filesize_width
      zy = y_min + (y_max - y_min) * y / filesize_height

      # マンデルブロ集合の計算
      z = 0.0
      iteration = 0
      while z.abs < 2 && iteration < max_iterations
        z = z * z + Complex(zx, zy)
        iteration += 1
      end

      # ピクセルの色を設定
      color = if iteration == max_iterations
                ChunkyPNG::Color::WHITE
              else
                ChunkyPNG::Color.rgb(iteration * 10 % 256, iteration * 10 % 256, iteration * 10 % 256)
              end

      # 画像に描画
      png[x, y] = color
    end
  end

  # 画像を保存
  png.save(output_path, interlace: true)
end

simple_execute if __FILE__ == $PROGRAM_NAME
