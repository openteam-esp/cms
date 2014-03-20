class API < Grape::API
  prefix :api
  format :json

  params do
    requires :url, type: String, desc: "Url for index"
  end
  post do
    MessageMaker.make_message('esp.cms.searcher', 'add', params[:url])
  end
end
