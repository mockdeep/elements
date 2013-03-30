class ElementsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @elements = current_user.elements.filtered_on(params[:view])
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
    params.require(:element).permit(:title, :value, :urgency, :done)
  end
end
