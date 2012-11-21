# -*- coding: utf-8 -*-

class Push
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :content, type: String
end
