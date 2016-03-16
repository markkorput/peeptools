# require 'FileUtils'
require 'peeptools/path'

module Peep
    class File
        include Path

        def mv to_path
            # move filesystem file
            FileUtils.mv(self.full_path, to_path)
            # exec("mv #{self.full_path} #{to_path}")
            # also change this instance's internal representation
            @path = to_path
        end

        def cd relative_path
            to_folder_path = ::File.expand_path(relative_path, ::File.dirname(self.full_path))
            self.mv(::File.join(to_folder_path, self.name))
        end
    end
end
