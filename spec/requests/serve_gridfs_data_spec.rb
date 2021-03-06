# -*- coding: utf-8 -*-

require 'spec_helper'

describe ServeGridfsData do

  before :each do
    @png_tag = Fabricate.build(:tag, code: 'png')
    @png_file = File.open(File.join(Rails.root, '/app/assets/images/rails.png'))
    @png_tag.image = @png_file
    @png_tag.save
    class TestDataUploader < CarrierWave::Uploader::Base
      include CarrierWave::MiniMagick
      def store_dir
        "td/#{model.id}"
      end
    end
    class TestModel
      include Mongoid::Document
      mount_uploader :data, TestDataUploader
    end
    @text_model = TestModel.new
    @text_file = File.open(File.join(Rails.root, '/Rakefile'))
    @text_model.data = @text_file
    @text_model.save
    @html_model = TestModel.new
    @html_file = File.open(File.join(Rails.root, '/public/500.html'))
    @html_model.data = @html_file
    @html_model.save
  end

  describe 'uploaded image' do

    it 'can be downloaded' do
      get @png_tag.image.url
      response.body.should_not == 'File not found.'
    end

    it 'content_type can be set' do
      get @png_tag.image.url
      response.headers['Content-Type'].should == 'image/png'
    end
  end

  describe 'uploaded text' do

    it 'can be downloaded' do
      get @text_model.data.url
      response.body.should_not == 'File not found.'
    end

    it 'content_type can be set' do
      get @text_model.data.url
      response.headers['Content-Type'].should == 'text/plain'
    end
  end

  describe 'uploaded html' do

    it 'can be downloaded' do
      get @html_model.data.url
      response.body.should_not == 'File not found.'
    end

    it 'content_type can be set' do
      get @html_model.data.url
      response.headers['Content-Type'].should == 'text/html'
    end
  end

  describe 'unknown path' do
    before :each do
      @unknown_path = @png_tag.image.url + '_'
    end

    it 'cannot be downloaded' do
      get @unknown_path
      response.body.should == 'File not found.'
    end

    it 'content_type is set to be text/plain' do
      get @unknown_path
      response.headers['Content-Type'].should == 'text/plain'
    end
  end
end
