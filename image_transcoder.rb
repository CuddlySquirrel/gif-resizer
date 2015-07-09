class ImageTranscoder

  require 'rmagick'

	def initialize(input_path, output_path)
    validate_args(input_path, output_path)
    (@input_path, @output_path, @basename ) = [input_path, output_path, File.basename(input_path)]
    @output_file = "#{@output_path}/#{@basename}"
  end

  def resize_to(new_size_in_b)
    # check the size
    new_size_in_b = new_size_in_b.to_f
    orig_size_in_b = File.stat(@input_path).size.to_f
    validate_resize_request(orig_size_in_b, new_size_in_b)

    # read the image file
    img = read_input_file

    # calculate ratio
    resize_ratio =  new_size_in_b/orig_size_in_b

    # reduce
    reduce(img, resize_ratio)

    # keep reducing
    until(File.stat(@output_file).size.to_f <= new_size_in_b)
      resize_ratio *= 0.99
      reduce(img, resize_ratio) 
    end
  end

  def reduce(img, resize_ratio)
    # get the new dimentions
    new_width = (img[0].columns * resize_ratio).to_i
    new_height = (img[0].rows * resize_ratio).to_i

    # process the frames
    frames = process_frames(img, new_width, new_height)

    # write the file
    write_file(frames)
  end

  def process_frames(img, new_width, new_height)
    frames = img.coalesce
    frames.each do |frame|
      frame.resize_to_fill!(new_width,new_height)
    end
    frames.optimize_layers(Magick::OptimizeLayer)
  end

  def write_file(frames)
    File.open( @output_file, 'wb'){ |file| file.write frames.to_blob }
  end

  def read_input_file
    img_file = File.new @input_path
    Magick::ImageList.new.from_blob(img_file.read)
  end

  def validate_args(input_path, output_path)
    unless(File.file? input_path)
      raise 'input_path must be a file that exists'
    end

    unless(File.directory? output_path)
      raise 'output_path must be a dir that exists'
    end

    absolute_input_path = File.absolute_path(input_path)
    absolute_output_path = File.absolute_path(output_path)
    unless(File.dirname(absolute_input_path) != absolute_output_path)
      raise 'specify an output_path different from the input_path dir'
    end
  end

  def validate_resize_request(orig_size_in_b, new_size_in_b)
    unless(new_size_in_b > 0)
      raise 'new_size_in_b must be a number greater then zero'
    end

    unless(new_size_in_b < orig_size_in_b)
      raise "new_size_in_b (#{new_size_in_b}) must be less then orig_size_in_b (#{orig_size_in_b})" 
    end
  end

end
