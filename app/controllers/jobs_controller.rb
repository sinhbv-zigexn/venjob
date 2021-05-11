class JobsController < ApplicationController
  def index
    # byebug
    rsolr = RSolr.connect url: Settings.core_url
    @search = rsolr.select params: {:q => "*:*"}
  end
end
