class NodesController < ApplicationController
  actions :show
  defaults :finder => :find_by_route
end
