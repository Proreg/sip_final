ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

ENV['NLS_LANG'] = 'BRAZILIAN PORTUGUESE_BRAZIL.UTF8'