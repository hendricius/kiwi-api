require 'uri'
require 'json'
require 'date'
require 'faraday'
require_relative 'flight_result'
require_relative 'batch_result'
require_relative 'helpers/core_helper'

module KiwiApi
  class ApiError < StandardError
    def initialize(msg, response: nil, original_exception: nil)
      @response           = response
      @original_exception = original_exception
    end
    attr_reader :response, :original_exception
  end

  class Client
    KIWI_BASE_URL = 'https://api.skypicker.com'
    KIWI_FLIGHTS_PATH = '/flights'
    KIWI_FLIGHTS_MULTI_PATH = '/flights_multi'

    def initialize(params: {})
      @params = params
    end
    attr_reader :params

    # Returns a list of flight results.
    #
    # Example:
    #
    # KiwiApi::Client.search_flights(fly_from: 'AMS', to: 'IBZ', date_from: '23/08/2017',
    #                                date_to: '01/09/2017', extra_params: {direct_flights: 1})
    #
    def self.search_flights(fly_from:, fly_to:, date_from:, **options)
      params = {fly_from: fly_from, fly_to: fly_to, date_from: date_from}
      new(params: options.merge(params)).search_flights
    end

    # Returns a list of flight results.
    #
    # Example:
    #
    # KiwiApi::Client.batch_search_flights([{fly_from: 'AMS', to: 'IBZ',
    #                                       date_from: '23/08/2017',
    #                                       date_to: '01/09/2017', {direct_flights: 1}])
    def self.batch_search_flights(request_params)
      new(params: request_params).batch_search_flights
    end

    def search_flights
      data = {
        direct_flights: 1,
      }.merge(params)

      response = request(params: CoreHelper.camelize_keys(data), endpoint: KIWI_FLIGHTS_PATH)
      response[:data].map { |flight_result_hash| FlightResult.new(flight_result_hash)}
    end

    def batch_search_flights
      request_params = params.map do |param|
        camelize(param.merge(direct_flights: 1))
      end

      endpoint = "/flights_multi"

      final_result = []
      request_params.each_slice(3) do |slice|
        response = request(params: {requests: slice}, endpoint: endpoint, method: :post)
        slice.each_with_index do |request, index|
          # handle response differently. quirks.
          if slice.length > 1
            results = response.map { |resp| resp[:route][index] }.compact
          else
            results = response.first
          end
          converted = results.map { |result| FlightResult.new(result) }
          final_result << BatchResult.new(request: request, results: converted)
        end
      end
      final_result
    end

    private

    def request(params:, endpoint:, method: :get)
      request_data_from_api(params: params, endpoint: endpoint, method: method)
    rescue Faraday::Error => e
      raise ApiError.new("HTTP error", original_exception: e)
    end

    def request_data_from_api(params:, endpoint:, method: :get)
      conn     = Faraday.new(KIWI_BASE_URL)
      response = conn.send(method) do |req|
        req.url endpoint
        req.body = params.to_json
        req.headers['Content-Type'] = 'application/json'
      end
      if response.success?
        parse_response(response.body)
      else
        raise ApiError.new("Response has invalid format", response: response)
      end
    end

    def parse_response(response_body)
      JSON.parse(response_body, symbolize_names: true)
    end

    def camelize(hash)
      CoreHelper.camelize_keys(hash)
    end
  end
end


