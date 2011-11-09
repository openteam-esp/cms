class UploadsController < ApplicationController
  actions :all, :except => [:show, :edit, :update]
end
