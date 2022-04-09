class SearchController < ApplicationController
  # before_action :check_login
  # authorize_resource

  def index
    redirect_back(fallback_location: items_path) if params[:query].blank?
    @query = params[:query]
    @items = Item.search(@query)
    @total_hits = @items.size 
    if current_user.role?(:admin)
      @customers = Customer.search(@query)
    end
  end
end
