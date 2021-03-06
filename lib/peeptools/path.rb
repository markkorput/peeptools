module Peep
    module Path
        attr_reader :options

        def initialize _opts = {}
            @options = _opts.is_a?(Hash) ? _opts : {:path => _opts}
        end

        def logger
            @logger_cache ||= options[:logger] || Logger.new(STDOUT).tap do |l|
                l.level = Logger::WARN
            end
        end

        def path
            @path || options[:path] || Dir.pwd
        end

        def full_path
            path =~ /^\// ? path : ::File.expand_path(path)
        end

        def name
            ::File.basename(path)
        end

        def exists?
            ::File.exist?(self.full_path)
        end

        def extension
            ::File.extname(self.full_path)
        end
    end
end
