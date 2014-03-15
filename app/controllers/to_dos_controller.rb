class ToDosController < InheritedResources::Base
  respond_to :json
  before_filter :authenticate_user!

  def index
    super do |format|
      format.json { render json: collection }
    end
  end

  private
  def collection
    @to_dos ||= end_of_association_chain.all
  end

  def begin_of_association_chain
    current_user
  end

  def permitted_params
    params.permit(:id, :to_do => [:id, :content, :due_date, :priority, :completed])
  end
end
