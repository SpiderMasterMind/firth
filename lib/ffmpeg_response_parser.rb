class FfmpegResponseParser
  # console logger is going to inherit from this?
  def initialize(options = {})
    @input = options.fetch(:io)
  end

  def process
    # process as ffmpeg - new lines
    # specifically uses stdout
    puts @input
    # puts @input.split("\n")
  end
end
