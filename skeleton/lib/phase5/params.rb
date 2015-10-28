require 'uri'
require 'byebug'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = Hash.new
      req_string = req.query_string
      req_body = req.body
      parse_www_encoded_form(req_string) unless req_string.nil?
      parse_www_encoded_form(req_body) unless req_body.nil?
      @params.merge!(route_params)
    end

    def [](key)
      @params.symbolize_keys![key.to_sym]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      key_value_array = URI::decode_www_form(www_encoded_form)
      key_value_array.each do |key, value|
        @current_scope = @params

        parsed_key = parse_key(key)
        parsed_key.each_with_index do |key, i|
          @current_scope[key] ||= (i == parsed_key.length - 1) ? value : {}
          @current_scope = @current_scope[key]
        end

        @current_scope = value
      end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
