module Legato
  module Management
    module Finder
      def base_uri
        "https://www.googleapis.com/analytics/v3/management"
      end

      def all(user, path=default_path)
        uri = if user.api_key
          # oauth + api_key
          base_uri + path + "?key=#{user.api_key}"
        else
          # oauth 2
          base_uri + path
        end

        begin
          json = user.access_token.get(base_uri + path).body
        rescue
          # service_account (oauth 2)
          headers = { headers: { "Authorization" => "Bearer #{user.access_token.options[:access_token]}" } }
          json = user.access_token.request(:get, base_uri + path, headers).body
        end
        
        MultiJson.decode(json)['items'].map {|item| new(item, user)}
      end
    end
  end
end
