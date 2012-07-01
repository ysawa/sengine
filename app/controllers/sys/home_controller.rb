# -*- coding: utf-8 -*-

class Sys::HomeController < Sys::ApplicationController
  def index
    @subtitle = nil
    @top_page = true
  end
end
