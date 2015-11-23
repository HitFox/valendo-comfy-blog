class Comfy::Blog::Category < ActiveRecord::Base

  self.table_name = 'comfy_blog_categories'

  belongs_to :blog
  has_many :categorizations
  has_many :posts, through: :categorizations
end
