class ElementsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    if params[:view] == 'leaf'
      @elements = current_user.elements.leafs
    elsif params[:view] == 'ranked'
      @elements = current_user.elements.ranked.leafs
    else
      @elements = current_user.elements.roots
    end
  end

  def new
    parent = current_user.elements.find_by_id(params[:parent_id])
    @element = current_user.elements.build
    @element.parent = parent
  end

  def create
    parent = current_user.elements.find_by_id(params[:parent_id])
    @element = current_user.elements.build(element_params)
    @element.parent = parent
    if @element.save
      redirect_to elements_path, :notice => 'Element created successfully'
    else
      flash.now[:error] = 'There was a problem creating your Element'
      render :new
    end
  end

  def edit
    @element = current_user.elements.find(params[:id])
  end

  def update
    @element = current_user.elements.find(params[:id])
    if @element.update_attributes(element_params)
      redirect_to elements_path, :notice => 'Element updated successfully'
    else
      flash.now[:error] = 'There was a problem updating your Element'
      render :edit
    end
  end

  def destroy
    element = current_user.elements.find(params[:id])
    element.destroy
    redirect_to elements_path, :notice => 'Element deleted'
  end

  private

  def element_params
    params[:element].try(:permit, :title, :value, :urgency, :done)
  end
end
