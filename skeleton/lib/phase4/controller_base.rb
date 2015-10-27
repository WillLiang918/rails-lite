require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    attr_reader :session

    def redirect_to(url)
      super
      @session.store_session(@res)
    end

    def render_content(content, content_type)
      super
      @session.store_session(@res)
    end

    # method exposing a `Session` object
    def session
      @session ||= Session.new(@res)
    end
  end
end