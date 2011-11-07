class PagesController < ApplicationController
  belongs_to :node, :shallow => true
end
