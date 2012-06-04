# -*- coding: utf-8 -*-

class AudioController < ApplicationController
  respond_to :mp3, :ogg, :wav

  # GET /audio/encode/put.mp3
  # GET /audio/encode/put.ogg
  # GET /audio/encode/put.wav
  def encode
    filename = params[:filename]
    format = params[:format]
    path = File.join(Rails.root, "app/assets/images/audio/#{filename}.#{format}")
    scheme = "data:audio/#{format};base64,#{Base64.encode64(File.open(path).read)}"
    render text: scheme, content_type: Mime::TEXT
  end
end
