# frozen_string_literal: true

require 'benchmark'

require './app/single_thread'
require './app/multi_thread'

Benchmark.bm 15 do |r|
  r.report 'single_thread' do
    single_thread_execute
  end
  r.report 'multi_thread' do
    multi_thread_execute
  end
end
