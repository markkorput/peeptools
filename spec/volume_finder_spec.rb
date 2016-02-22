require File.dirname(__FILE__) + '/spec_helper'

require 'peeptools/volume_finder'

describe Peep::VolumeFinder do
    let(:volume_finder){
        Peep::VolumeFinder.new
    }

    describe '.folder' do
        it 'returns nil when no relevant volumes found' do
            expect(volume_finder.folder).to eq nil
        end

        it 'returns a gopro folder object when any volume is found' do
            stubstub(Peep::GoproFolder.new('/Volumes/GPRO1'))
            expect(volume_finder.folder.class).to eq Peep::GoproFolder
        end
    end
    
    describe '.folders' do
        it 'returns an array of matching folders' do
            expect(volume_finder.folders).to eq []
        end
        
        it 'only returns recognised gopro volume folders inside /Volumes' do
            stubstub(Peep::GoproFolder.new('/Volumes/GOPRO'))
            folders = volume_finder.folders
            expect(folders.map(&:class)).to eq [Peep::GoproFolder]
            expect(folders.map(&:path)).to eq ['/Volumes/GOPRO']
        end
    end
end
