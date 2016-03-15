require 'peeptools/volume_finder'
require 'peeptools/importer'

module Peep
  class ImportSession
    attr_reader :options

    def initialize _opts = {}
      @options = _opts
    end

    def logger
        @logger ||= options[:logger] || Logger.new(STDOUT).tap do |l|
            l.level = Logger::WARN
        end
    end

    def require_import_confirmation?
      options[:require_import_confirmation] != false
    end

    def request_import_confirmation
      logger.warn "ImportSession.request_import_confirmation not implemented yet; can't ask for confirmation"
      return true
      value = gets.to_s.downcase
      return value == 'y' || value == 'yes'
    end

    def ejects?
      options[:eject] != false
    end

    def volume_finder
      @volume_finder_cache ||= VolumeFinder.new(:volumes_folder => options[:volumes_folder], :logger => logger)
    end

    def importer gopro_folder
      Importer.new(:folder => gopro_folder, :import_folder => options[:import_folder], :logger => logger)
    end

    def update
      # get all GoPro volumes we can find
      volume_finder.folders.each do |folder|
        # Create an importer for the GoPro folder
        importer = importer(folder)

        # only process GoPro volumes if the target folder doesn't already exist
        next if importer.target_folder.exists?

        # ask user confirmation if necessary
        if require_import_confirmation? == true
          puts "Import from #{importer.source_folder.name}?"
          next if request_import_confirmation != true
        end

        # perform import
        importer.import
        importer.mark_as_imported
        importer.eject if self.ejects?
        self.sound(importer.source_folder.name) if self.sound?
      end
    end

    def sound?
      options[:sound] != false
    end

    def sound(volume_name = nil)
        system(volume_name ? "say import of \'#{volume_name}\' done" : 'say import done')
    end
  end
end


# import_session = ImportSession.new
# while true
#   import_session.update
# end
#
# ---
#
# # keep looking/waiting for new volumes to import until the user aborts
# def update
#   # get all GoPro volumes we can find
#   folders = volume_finder # Peep::VolumeFinder.new(:logger => logger).folders
#
#   # deal with each found GoPro folder
#   folders.each do |folder|
#     # Create an importer for the GoPro folder
#     importer = importer(folder) # Peep::Importer.new(:folder => folder, :logger => logger)
#
#     # only process GoPro volumes if the target folder doesn't already exist
#     if !importer.target_folder.exists?
#       # ask user confirmation if necessary
#       if require_import_confirmation? != true || request_import_confirmation == true
#         # perform import
#         importer.import
#       end
#     end
#   end
# end
#
#
