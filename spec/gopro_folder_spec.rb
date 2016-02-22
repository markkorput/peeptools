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
        
        it 'looks for a DCIM/100GOPRO subfolder' do
            expect(File).to receive(:exist?).with('/Volumes/GOPRO/DCIM/100GOPRO').and_return(true)
            expect(File).to receive(:exist?).with('/Volumes/GOPRO/MISC').and_return(true) # this just surpresses the logger warning of a missing MISC folder
            expect(gopro_folder.is_gopro?).to eq true
        end
    end
    
    describe '.folder' do
        it 'returns a GoproFolder object' do
            expect(gopro_folder.folder('child').class).to eq Peep::GoproFolder
        end
    end
    
    describe ".number" do
        it "gives the trailing digits from the GoPro volume folder name" do
            expect(Peep::GoproFolder.new('/Volumes/GPRO001').number).to eq '001'
        end
        
        it "gives the first group of digits in the folder name if the folder name doesn't end with digits" do
            expect(Peep::GoproFolder.new('/Volumes/GP123RO').number).to eq '123'
            expect(Peep::GoproFolder.new('/Volumes/GP12_34RO').number).to eq '12'
        end
    end
end
