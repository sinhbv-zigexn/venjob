namespace :solr do
  task index: :environment do
    IndexSolr.execute
  end
end
