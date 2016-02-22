require 'peeptools/folder'
require 'peeptools/gopro_folder'

module Peep
    class VolumeFinder
        attr_reader :options

        def initialize opts = {}
            
        end

        def folder
            folders.first
        end

        def folders
            a= Folder.new('/Volumes').folders.map do |folder|
                f = Peep::GoproFolder.new(folder.full_path)
                f.is_gopro? ? f : nil
            end.compact
            # byebug
        end
    end
end



# class VolumeFinder
#   attr_reader :options

#   def initialize opts = {}
#     @options = opts
#   end

#   def logger
#     @logger ||= options[:logger] || Logger.new(STDOUT).tap do |l|
#       l.level = Logger::DEBUG
#     end
#   end

#   def matcher
#     options[:volume_matcher] || CONFIG[:volume_matcher]
#   end

#   def folders
#     @folders ||= Dir.glob('/Volumes/*')
#   end

#   def matching_folders
#     folders.select{|f| f =~ matcher}
#   end

#   def folder
#     return matching_folders.first if matching_folders.length == 1

#     raise 'Volume not found' if matching_folders.length == 0
#     raise "More than one matching volume found: #{matching_folders.inspect}"
#   end
# end
