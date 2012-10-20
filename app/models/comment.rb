class Comment
  include Mongoid::Document
  field :content, type: String
end
