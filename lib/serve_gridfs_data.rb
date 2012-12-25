# -*- coding: utf-8 -*-

class ServeGridfsData
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] =~ /^\/g\/(.+)$/
      process_request(env, $1)
    else
      @app.call(env)
    end
  end

private
  def process_request(env, path)
    begin
      grid_fs = CarrierWave::Storage::GridFS::File.new(nil, path)
      data = grid_fs.read
      raise if data.blank?
      content_type = (MIME::Types.type_for(path)[0] || 'text/plain').to_s
      [200, { 'Content-Type' => content_type }, [data]]
    rescue
      [404, { 'Content-Type' => 'text/plain' }, ['File not found.']]
    end
  end
end
