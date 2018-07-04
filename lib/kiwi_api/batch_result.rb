require 'hashie'
require_relative 'helpers/core_helper'

module KiwiApi
  class BatchResult
    def initialize(request:, results: [])
      @request = request || {}
      @results = results
    end
    attr_reader :request, :results

    def fly_from
      @request[:flyFrom]
    end

    def fly_to
      @request[:to]
    end

    def actual_fly_from
      @results.first[:fly_from]
    end

    def actual_fly_to
      @results.first[:fly_to]
    end
  end
end
