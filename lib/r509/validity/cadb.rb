require 'r509'

unless Kernel.respond_to?(:require_relative)
  module Kernel
    def require_relative(path)
      require File.join(File.dirname(caller[0]), path.to_str)
    end
  end
end

module R509::Validity::CADB
  require_relative('cadb/checker.rb')
end

