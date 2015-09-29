class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :detect_robots_in_development if Rails.env.development?

  layout 'with_tree'

  respond_to :html, :json

  private

  def detect_robots_in_development
    puts "\n\n"
    puts "DEBUG ---> #{request.user_agent.to_s}"
    puts "Current locale: #{I18n.locale}"
    puts "Params: #{params}"
    puts "\n\n"

    render :nothing => true, status: :forbidden and return if request.user_agent.to_s.match(/\(.*https?:\/\/.*\)/)
  end
end
