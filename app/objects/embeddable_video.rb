class EmbeddableVideo < SimpleDelegator
  class Base
    def initialize(video)
      @video = video
    end

    protected

    attr_reader :video
  end

  class VimeoVideo < Base
    def url
      if video.url.match(/player/)
        video.url
      else
        video_id = URI.parse(video.url).path.gsub("/", "")
        "https://player.vimeo.com/video/#{video_id}"
      end
    end
  end

  class YouTubeVideo < Base
    def url
      video.url.sub("watch?v=", "embed/")
    end
  end

  class InstagramVideo < Base
    def url
      video.url
    end
  end

  class UnsupportedHost < RuntimeError; end

  def self.host_supported?(url)
    CONFIG.keys.any? { |regex| url.match(regex) }
  end

  def initialize(model)
    obj = if model.from_instagram?
            instagram_module = InstagramWrapperFactory.call

            client = instagram_module::Client.unauthenticated_client
            instagram_video = instagram_module::InstagramVideo.new_from_model(model, client)
            DelegationChain.new(model, instagram_video)
          else
            model
          end
    super(obj)
  end

  def class
    __getobj__.class
  end

  def url
    host = URI.parse(__getobj__.url).host

    raise UnsupportedHost if host.nil?

    CONFIG.each do |regex, klass|
      return klass.new(__getobj__).url if host.match(regex)
    end

    raise UnsupportedHost
  end

  private

  CONFIG = {
    /vimeo/ => VimeoVideo,
    /youtube/ => YouTubeVideo,
    /instagram/ => InstagramVideo,
  }
end
