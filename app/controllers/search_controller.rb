class SearchController < ApplicationController
  # before_action :check_login
  # authorize_resource

  def show
    redirect_back(fallback_location: items_path) if params[:query].blank?
    @query = params[:query]
    @items = Item.search(@query)
    @total_hits = @items.size 
  end
end
