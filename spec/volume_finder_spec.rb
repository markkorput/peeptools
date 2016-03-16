require File.dirname(__FILE__) + '/spec_helper'

require 'peeptools/volume_finder'

describe Peep::VolumeFinder do
    let(:volume_finder){ Peep::VolumeFinder.new }

    describe '.volumes_folder' do
        it 'gives a Folder instance' do
            expect(volume_finder.volumes_folder.class).to eq Peep::Folder
        end

        it 'defaults to the /Volumes folder' do
            expect(volume_finder.volumes_folder.path).to eq '/Volumes'
        end

        it 'can be configured through the :volumes_folder option' do
            expect(Peep::VolumeFinder.new(:volumes_folder => '/vumes').volumes_folder.path).to eq '/vumes'
        end
    end

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

        it 'only returns recognised gopro volume folders inside the configured volumes_folder' do
            volume_finder = Peep::VolumeFinder.new(:volumes_folder => File.expand_path('fixtures/Volumes', File.dirname(__FILE__)))
            expect(volume_finder.folders.map(&:name)).to eq ['GOPRO3']
        end

        it 'only returns recognised gopro volume folders inside the default volumes_folder if no volumes_folder configured' do
            stubstub(Peep::GoproFolder.new('/Volumes/GOPRO'))
            folders = volume_finder.folders
            expect(folders.map(&:class)).to eq [Peep::GoproFolder]
            expect(folders.map(&:path)).to eq ['/Volumes/GOPRO']
        end
    end
end
