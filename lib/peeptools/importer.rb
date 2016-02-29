require 'peeptools/gopro_folder'

module Peep
    class Importer
        attr_reader :options

        def initialize _opts = {}
            @options = _opts.is_a?(Hash) ? _opts : {:folder => _opts}
            @cwd = Dir.pwd
        end

        def logger
            @logger ||= options[:logger] || Logger.new(STDOUT).tap do |l|
                l.level = Logger::DEBUG
            end
        end

        def folder
            options[:folder].is_a?(String) ? GoproFolder.new(options[:folder]) : options[:folder] || GoproFolder.new
        end

        alias :source_folder :folder

        def import_folder
            options[:import_folder] ? Folder.new(options[:import_folder]) : Folder.new(@cwd)['_IMPORT']
        end

        def target_folder
            import_folder[source_folder.name]
        end

        def command
            "rsync -ah --progress #{folder.video_file_selector} #{target_folder.full_path}"
        end

        def import
            logger.info "Found #{folder.video_files.length} files:\n#{folder.video_files.map(&:full_path).join("\n")}"
            target_folder.create(:force => true)
            logger.info "Running command:\n#{command}"
            exec(command)
            logger.info "rsync done."
        end
        
        def imported_folders
            import_folder.folders
        end
    end
end
