class ElementsController < ApplicationController
  def index
    @elements = current_user.elements.root_elements
  end

end
