require 'peeptools/file'
require 'peeptools/folder'

module Peep
    class GoproFolder < Folder
        
        def is_gopro?
            return false unless folder('DCIM/100GOPRO').exists?
            logger.warn "No MISC folder found, but considering #{self.full_path} a valid GoPro volume anyway" if !folder('MISC').exists?
            return true
        end
        
        def number
            (self.name.match(/\d+$/) || [])[0] ||
            (self.name.match(/\d+/) || [])[0]
        end
        
        def video_file_selector
            ::File.join(full_path, 'DCIM', '100GOPRO', '*.MP4')
        end

        def video_file_paths
            Dir.glob(video_file_selector)
        end

        def video_files
            video_file_paths.map{|p| File.new(p)}
        end
    end
end