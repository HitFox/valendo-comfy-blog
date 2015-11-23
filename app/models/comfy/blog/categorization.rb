class Comfy::Blog::Categorization < ActiveRecord::Base

  self.table_name = 'comfy_blog_categorizations'

  belongs_to :post
  belongs_to :category
end
