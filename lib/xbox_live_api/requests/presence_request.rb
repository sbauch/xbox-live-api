require 'xbox_live_api/requests/base_request'
require 'xbox_live_api/profile'
require 'oj'
require 'pry'

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
        print params
        HttpSessionGateway.new.post_json(url, header: header_for_version(Version::NEXT).merge('Host': 'userpresence.xboxlive.com'), body: params).body
      end

      def handle_response(resp, user_id)
        binding.pry
        json = Oj.load(resp)
        settings = json['profileUsers'].first['settings']
        settings_hash = collect_settings(settings)
        Profile.new(id: user_id,
                    gamertag: settings_hash['Gamertag'],
                    gamerscore: settings_hash['Gamerscore'].to_i,
                    gamer_picture: settings_hash['GameDisplayPicRaw'],
                    account_tier: settings_hash['AccountTier'],
                    xbox_one_rep: settings_hash['XboxOneRep'],
                    preferred_color_url: settings_hash['PreferredColor'],
                    tenure_level: settings_hash['TenureLevel'].to_i)
      end

      def collect_settings(settings)
        settings_hash = {}
        settings.each do |setting|
          settings_hash.store(setting['id'], setting['value'])
        end
        settings_hash
      end
    end
  end
end