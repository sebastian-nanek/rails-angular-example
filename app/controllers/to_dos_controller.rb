class ToDosController < InheritedResources::Base
  respond_to :html, :json

  private
  def collection
    @to_dos ||= ToDo.all
  end
end
