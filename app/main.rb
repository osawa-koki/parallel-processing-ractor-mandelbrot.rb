# frozen_string_literal: true

require 'benchmark'

require './app/simple'
require './app/multi_thread'

Benchmark.bm 15 do |r|
  r.report 'simple' do
    simple_execute
  end
  r.report 'multi_thread' do
    multi_thread_execute
  end
end
