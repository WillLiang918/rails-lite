require_relative '../phase3/controller_base'
require_relative './session'

module Phase4
  class ControllerBase < Phase3::ControllerBase
    attr_reader :session

    def redirect_to(url)
      super(url)
      self.session.store_session(@res)
    end

    def render_content(content, content_type)
      super(content, content_type)
      self.session.store_session(@res)
    end

    # method exposing a `Session` object
    def session
      @session ||= Phase4::Session.new(@res)
    end
  end
end
