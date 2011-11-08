class UploadsController < InheritedResources::Base
  actions :all, :except => [:show, :edit, :update]
end
