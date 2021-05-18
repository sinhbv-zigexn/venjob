class QueueDocumentWorker
  @queue = :default

  def self.perform
    User.first
  end
end
