require 'peeptools/path'
require 'peeptools/file'

module Peep
    class Folder
        include Path

        def folder _path
            self.class.new(::File.join(path, _path.to_s))
        end

        alias :[] :folder
        
        def children_paths
            Dir.glob(::File.join(self.full_path, '*'))
        end

        def folders
            children_paths.select{|p| ::File.directory?(p)}.map{|p| self.class.new(p)}
        end

        def create opts = {}
            return if self.exists?

            if !parent.exists?
                if opts[:force] == true
                    parent.create(:force => true)
                else
                    # abort
                    logger.warn "Can't create folder at #{full_path} without :force => true options, because parent doesn't exist"
                    return
                end
            end

            logger.info "Creating folder #{full_path}"
            Dir.chdir(parent.full_path)
            Dir.mkdir(name)
        end

        def remove opts = {}
            if opts[:force] == true
                exec("rm -rf #{full_path}")
            else
               Dir.rmdir(full_path)
            end
        end

        def parent
            self.class.new(self.full_path.split(::File::SEPARATOR)[0..-2].join(::File::SEPARATOR))
        end
    end
end