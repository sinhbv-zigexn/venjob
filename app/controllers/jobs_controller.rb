class JobsController < ApplicationController
  def index
    IndexSolr.perform
    rsolr = RSolr.connect url: Settings.core_url
    result = rsolr.select params: { q: '*:*' }
    @search = result['response']
  end
end
