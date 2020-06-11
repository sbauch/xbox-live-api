class XboxLiveApi
  module Requests
    class BaseRequest
      class Version
        XBOX_360 = 1
        XBOX_ONE = 2
        NEXT = 3
      end

      def initialize(auth_header)
        @auth_header = auth_header
      end

      def header_for_version(version)
        {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'Accept-Language' => 'en-US',
            'Authorization' => @auth_header,
            'x-xbl-contract-version' => version
        }
      end
    end
  end
end