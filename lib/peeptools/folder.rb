module Peep
    class Folder
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
            options[:path] || Dir.pwd
        end
        
        def full_path
            path =~ /^\// ? path : File.expand_path(path)
        end
        
        def name
            File.basename(path)
        end
        
        def exists?
            File.exist?(self.full_path)
        end
        
        def folder _path
            self.class.new(File.join(path, _path.to_s))
        end

        alias :[] :folder
        
        def children_paths
            Dir.glob(File.join(self.full_path, '*'))
        end

        def folders
            children_paths.select{|p| File.directory?(p)}.map{|p| self.class.new(p)}
        end
    end
end