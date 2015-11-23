class Comfy::Admin::Blog::CategorizationsController < Comfy::Admin::Blog::BaseController

  before_action :load_blog
  before_action :build_categorization, :only => [:new, :create]
  before_action :load_categorization,  :only => [:edit, :update, :destroy]

  def index
    @categorizations = comfy_paginate(@blog.categorizations.order(:created_at))
  end

  def new
    render
  end

  def create
    @categorization.save!
    flash[:success] = t('comfy.admin.blog.categorizations.created')
    redirect_to :action => :edit, :id => @categorization

  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = t('comfy.admin.blog.categorizations.create_failure')
    render :action => :new
  end

  def edit
    render
  end

  def update
    @categorization.update_attributes!(categorization_params)
    flash[:success] = t('comfy.admin.blog.categorizations.updated')
    redirect_to :action => :edit, :id => @categorization

  rescue ActiveRecord::RecordInvalid
    flash.now[:error] = t('comfy.admin.blog.categorizations.update_failure')
    render :action => :edit
  end

  def destroy
    @categorization.destroy
    flash[:success] = t('comfy.admin.blog.categorizations.deleted')
    redirect_to :action => :index
  end

protected

  def load_categorization
    @categorization = @blog.categorizations.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = t('comfy.admin.blog.categorizations.not_found')
    redirect_to :action => :index
  end

  def build_categorization
    @categorization = @blog.categorizations.new(categorization_params)
  end

  def categorization_params
    params.fetch(:categorization, {}).permit!
  end

end
