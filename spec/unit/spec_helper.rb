# coding: UTF-8

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'libraries'))
require 'rspec'
require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.order = 'random'
  config.expect_with(:rspec) { |c| c.syntax = :expect }
end

module CernerSplunk
  # Need a way to reset the cached module level variables between specs
  def self.reset
    @my_cluster_data = nil
    @all_cluster_data = nil
  end
end
