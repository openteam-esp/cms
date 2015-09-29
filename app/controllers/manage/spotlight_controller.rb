class Manage::SpotlightController < Manage::ApplicationController

  def proxy
    render :json => Spotlight.new(params[:url]).response_hash
  end

end
