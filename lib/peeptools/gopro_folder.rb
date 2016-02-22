require 'peeptools/folder'

module Peep
    class GoproFolder < Folder
        
        def is_gopro?
            return false unless folder('DCIM/100GOPRO').exists?
            logger.warn "No MISC folder found, but considering #{self.full_path} a valid GoPro volume anyway" if !folder('MISC').exists?
            return true
        end
    end
end