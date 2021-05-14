class IndexSolr
  require 'net/ftp'
  require 'zip'
  require 'csv'

  DESTINATION = 'tmp/storage/ftp'.freeze

  class << self
    def execute
      download_file
      extract_downloaded_file
      import_to_sorl
    end

    def download_file
      FileUtils.mkdir_p "#{Rails.root}/#{DESTINATION}"
      ftp = Net::FTP.new
      ftp.connect(Settings.ftp.ip, '21')
      ftp.login(Settings.ftp.username, Settings.ftp.password)
      ftp.passive = true
      ftp.getbinaryfile(Settings.ftp.file_name, "#{DESTINATION}/#{Settings.ftp.file_name}")
      ftp.close
    end

    def extract_downloaded_file
      zip_file = Zip::File.new "#{DESTINATION}/#{Settings.ftp.file_name}"
      @entry_name = zip_file.glob('*.csv').first
      FileUtils.rm_f "#{DESTINATION}/#{@entry_name}"
      zip_file.extract @entry_name, "#{DESTINATION}/#{@entry_name}"
    end

    def import_to_sorl
      rsolr = RSolr.connect url: Settings.core_url
      body = File.read("#{DESTINATION}/#{@entry_name}")
      docs = CSV.parse(body, headers: :first_row).map(&:to_h)
      docs.map {|doc| doc["work place"].tr! '[]"', ''}
      rsolr.delete_by_query '*:*'
      rsolr.add docs
      rsolr.commit
    end
  end
end
