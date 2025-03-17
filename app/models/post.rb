class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy  # Ensure comments are deleted with the post  

end
