# frozen_string_literal: true

require 'rspec'
require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/../src")
loader.setup
