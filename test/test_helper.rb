$LOAD_PATH.unshift File.expand_path("../../lib", __dir__)
require 'rokku'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/pride'
require 'hanami/model'
require 'setup.rb'
include Hanami::Rokku
