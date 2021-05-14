class QueueDocumentWorker
  @queue = :default

  def self.perform
    Resque.logger.info '======================Start index======================'
    Rake::Task['solr:index'].invoke
    Resque.logger.info '======================Finish index======================'
  end
end
