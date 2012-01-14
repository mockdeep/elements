class ElementsController < ApplicationController
  def index
    @elements = current_user.elements.root_elements
  end

  def new
    @element = current_user.elements.build(:parent_id => params[:parent_id])
  end

  def create
    @element = current_user.elements.build(params[:element])
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
    if @element.update_attributes(params[:element])
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
end