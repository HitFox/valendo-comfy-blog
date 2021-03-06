class Comfy::Blog::PostsController < Comfy::Blog::BaseController

  skip_before_action :load_blog, :only => [:serve]

  # due to fancy routing it's hard to say if we need show or index
  # action. let's figure it out here.
  def serve
    # if there are more than one blog, blog_path is expected
    if @cms_site.blogs.count >= 2
      params[:blog_path] = params.delete(:slug) if params[:blog_path].blank?
    end

    load_blog

    if params[:slug].present? && @blog.categories.where(:slug => params[:slug]).empty?
      show && render(:show)
    else
      index && render(:index)
    end
  end

  def index
    @categories = @blog.categories
    scope = if params[:year]
      scope = @blog.posts.published.for_year(params[:year])
      params[:month] ? scope.for_month(params[:month]) : scope
    elsif params[:slug]
      @category = @categories.where(:slug => params[:slug]).first!
      scope = @category.posts.published
    else
      @blog.posts.published
    end

    limit = ComfyBlog.config.posts_per_page
    respond_to do |format|
      format.html do
        @posts = comfy_paginate(scope, limit)
      end
      format.rss do
        @posts = scope.limit(limit)
      end
    end
  end

  def show
    @categories = @blog.categories
    @post = if params[:slug] && params[:year] && params[:month]
      @blog.posts.published.where(:year => params[:year], :month => params[:month], :slug => params[:slug]).first!
    else
      @blog.posts.published.where(:slug => params[:slug]).first!
    end
    @comment = @post.comments.new

    @posts = @blog.posts.where.not(id: @post.id).last(3)

  rescue ActiveRecord::RecordNotFound
    render :cms_page => '/404', :status => 404
  end

end
