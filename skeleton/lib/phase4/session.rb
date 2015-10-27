require 'json'
require 'webrick'
require 'byebug'
module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash

    attr_reader :cookies

    def initialize(req)
      @req = req
      cookie = req.cookies.find { |cookie| cookie.name == '_rails_lite_app' }
      # value = JSON.parse(cookie.to_json)["value"]
      # @cookies = cookie ? JSON.parse(cookie.value) : {}
      @cookies = cookie ? JSON.parse(cookie.value) : Hash.new {[]}
    end

    def [](key)
      @cookies[key]
    end

    def []=(key, val)
      @cookies[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie ||= WEBrick::Cookie.new('_rails_lite_app', @cookies.to_json)
      res.cookies << cookie
    end
  end
end
