# frozen_string_literal: true

module Api
  module V1
    # This class is the main entry point of the application
    class ApplicationController
      RESPONSE_STATUSES = {
        'STATUS_SUCCESS' => 0,
        'STATUS_GENERIC_ERROR' => 1
      }.freeze

      attr_accessor :params, :request

      def initialize(request)
        self.request = request
      end

      def index
        'Put this in your **** & ***** it!'
      end

      private

      def parse_request_body
        self.params = JSON.parse(request.body.read.gsub('\r', ''))
      end

      def render(data: {}, status: 'STATUS_SUCCESS', metadata: nil)
        raise 'Invalid status' unless RESPONSE_STATUSES.key?(status)

        {
          status: RESPONSE_STATUSES[status],
          metadata:,
          data:
        }.to_json
      end
    end
  end
end
