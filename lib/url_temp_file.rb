class URLTempfile < Tempfile
  
  def initialize(url, tmpdir = Dir.tmpdir, options)
    @url = URI.parse(url)

    begin
      super('url', tmpdir, options)

      Net::HTTP.start(@url.host) do |http|
        resp = http.get(@url.path)
        self.write resp.body
      end
    ensure
    end
  end
  
end