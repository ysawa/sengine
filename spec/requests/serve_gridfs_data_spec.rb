# -*- coding: utf-8 -*-

require 'spec_helper'

describe ServeGridfsData do

  before :each do
    @tag = Fabricate.build(:tag)
    @file = File.open(File.join(Rails.root, '/app/assets/images/rails.png'))
    @tag.image = @file
    @tag.save
  end

  describe 'uploaded image' do

    it 'can be downloaded' do
      get @tag.image.url
      response.body.should_not == 'File not found.'
    end

    it 'content_type can be set' do
      get @tag.image.url
      response.headers['Content-Type'].should == 'image/png'
    end
  end

  describe 'unknown path' do
    before :each do
      @unknown_path = @tag.image.url + '_'
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
