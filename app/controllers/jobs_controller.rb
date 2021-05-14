class JobsController < ApplicationController
  def index
    rsolr = RSolr::Ext.connect url: Settings.core_url
    @categories = rsolr.find(facets: {fields: ['category']})[:facet_counts][:facet_fields][:category] - [0]
    @work_places = rsolr.find(facets: {fields: ['work_place']})[:facet_counts][:facet_fields][:work_place] - [0]
    query_params = params[:keyword].presence ? {phrases: params[:keyword]} : {queries: '*:*'}
    query_params[:fl] = ['work_place', 'salary', 'name', 'description']
    filter = {}
    filter[:category] = params[:category] if params[:category].presence
    filter[:work_place] = params[:work_place] if params[:work_place].presence
    query_params[:phrase_filters] = filter if filter.presence
    @result = rsolr.find(query_params)[:response]
    @total = @result[:numFound]
    @jobs = @result[:docs]
  end
end
