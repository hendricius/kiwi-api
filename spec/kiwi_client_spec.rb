require 'spec_helper'

describe KiwiApi::Client do
  describe ".search_flights" do
    it "returns an array of flight result params" do
      mock_response

      response = described_class.search_flights(valid_params)
      expect(response.first).to be_a(KiwiApi::FlightResult)
    end

    it "renders an api error when there is an issue with the connection" do
      mock_response do
        raise Faraday::Error
      end

      expect { described_class.search_flights(valid_params) }.to raise_error(KiwiApi::ApiError)
    end
  end

  describe ".batch_search_flights" do

    it "returns an array of results for each request" do
      mock_response(file: "batch-flights.json")
      response = described_class.batch_search_flights([valid_params, valid_params])

      expect(response).to be_a(Array)
    end

    it "raises an ApiError in case there is an error" do
      mock_response do
        raise Faraday::Error
      end

      expect { described_class.batch_search_flights([valid_params, valid_params]) }.to raise_error(KiwiApi::ApiError)
    end
  end

  def valid_params
    @valid_params ||= {
      fly_from: "HAM",
      fly_to: "AMS",
      date_from: "31/01/2019",
      date_to: "15/02/2019",
      direct_flights: 1,
      limit: 1
    }
  end

  def mock_response(file: "flight-search.json")
    allow_any_instance_of(KiwiApi::Client).to receive(:request_data_from_api) do
      yield if block_given?
      folder   = File.expand_path(File.dirname(__FILE__))
      path     = "#{folder}/fixtures/#{file}"
      response = File.read(path)
      JSON.parse(response, symbolize_names: true)
    end
  end
end
