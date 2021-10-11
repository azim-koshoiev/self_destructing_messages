module AppServices
  class BuildMessageLink
    include Rails.application.routes.url_helpers

    def initialize(params)
      @message = params[:message]

      raise ArgumentError if @message.nil?
    end

    def self.call(params = nil)
      new(params).call
    end

    def call
      link = api_message_url(message.id)
      OpenStruct.new(success?: true, payload: link)
    end

    private

    attr_reader :message
  end
end
  