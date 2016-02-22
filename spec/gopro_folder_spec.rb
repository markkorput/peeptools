require File.dirname(__FILE__) + '/spec_helper'

require 'peeptools/gopro_folder'

describe Peep::GoproFolder do
    let(:gopro_folder){
        Peep::GoproFolder.new('/Volumes/GOPRO')
    }
    
    it 'inherits from Peep::Folder' do
        expect(Peep::GoproFolder.superclass).to eq Peep::Folder
    end

    describe '.is_gopro' do
        it 'tells if the current folder is recognised as a gorpo volume' do
            expect(gopro_folder.is_gopro?).to eq false
        end
        
        it 'looks for a DCIM/100GOPRO and MISC folders' do
            
        end
    end
end
