class ToDosController < InheritedResources::Base
  respond_to :js, :json

  private
  def collection
    @to_dos ||= ToDo.all
  end
end
