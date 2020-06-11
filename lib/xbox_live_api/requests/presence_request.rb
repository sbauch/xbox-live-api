require 'xbox_live_api/requests/base_request'
require 'xbox_live_api/profile'
require 'oj'

class XboxLiveApi
  module Requests
    class PresenceRequest < BaseRequest

      def for(user_ids)
        resp = make_request(Array(user_ids))
        handle_response(resp, user_ids)
      end

      private

      def make_request(user_ids)
        url = 'https://userpresence.xboxlive.com/users/batch'
        params = {
            'users' => user_ids
        }
        
        HttpSessionGateway.new.post_json(url, header: header_for_version(Version::NEXT).merge('Host': 'userpresence.xboxlive.com'), body: params).body
      end

      def handle_response(resp, user_id)
        json = Oj.load(resp)
        # TODO: PresenceRecord, DeviceRecord classes

        json
      end
    end
  end
end