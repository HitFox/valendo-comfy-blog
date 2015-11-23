class Comfy::Admin::Blog::CategoriesController < Comfy::Admin::Blog::BaseController

  before_action :load_blog
  before_action :build_category, :only => [:new, :create]
  before_action :load_category,  :only => [:edit, :update, :destroy]

  def index
    @categories = comfy_paginate(@blog.categories.order(:name))
  end

  def new
    render
  end

  def create
    @category.save!
    flash[:success] = t('comfy.admin.blog.categories.created')
    redirect_to :action => :edit, :id => @category

  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = t('comfy.admin.blog.categories.create_failure')
    render :action => :new
  end

  def edit
    render
  end

  def update
    @category.update_attributes!(category_params)
    flash[:success] = t('comfy.admin.blog.categories.updated')
    redirect_to :action => :edit, :id => @category

  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = t('comfy.admin.blog.categories.update_failure')
    render :action => :edit
  end

  def destroy
    @category.destroy
    flash[:success] = t('comfy.admin.blog.categories.deleted')
    redirect_to :action => :index
  end

protected

  def load_category
    @category = @blog.categories.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t('comfy.admin.blog.categories.not_found')
    redirect_to :action => :index
  end

  def build_category
    @category = @blog.categories.new(category_params)
  end

  def category_params
    params.fetch(:category, {}).permit!
  end

end
