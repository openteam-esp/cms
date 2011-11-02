require "spec_helper"

describe LocalesController do
  describe "routing" do

    it "routes to #index" do
      get("/locales").should route_to("locales#index")
    end

    it "routes to #new" do
      get("/locales/new").should route_to("locales#new")
    end

    it "routes to #show" do
      get("/locales/1").should route_to("locales#show", :id => "1")
    end

    it "routes to #edit" do
      get("/locales/1/edit").should route_to("locales#edit", :id => "1")
    end

    it "routes to #create" do
      post("/locales").should route_to("locales#create")
    end

    it "routes to #update" do
      put("/locales/1").should route_to("locales#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/locales/1").should route_to("locales#destroy", :id => "1")
    end

  end
end
