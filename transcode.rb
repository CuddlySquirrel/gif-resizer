#!/usr/bin/env ruby
require_relative 'image_transcoder'
imageTranscoder = ImageTranscoder.new(ARGV[0], ARGV[1])
imageTranscoder.resize_to(ARGV[2])


