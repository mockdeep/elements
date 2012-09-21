attributes :id
attributes :title => :name, :rank => :size

node :children do |element|
  element.children.map do |child_element|
    partial("elements/tree", :object => child_element)
  end
end
