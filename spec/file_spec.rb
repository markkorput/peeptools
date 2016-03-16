require File.dirname(__FILE__) + '/spec_helper'

require 'peeptools/file'

describe Peep::File do
    let(:path){
        ::File.expand_path('fixtures/Volumes/GOPRO3/DCIM/100GOPRO/vid2.MP4', ::File.dirname(__FILE__))
    }

    let(:file){
        Peep::File.new(path)
    }

    describe '.extension' do
        it 'gives the extension' do
            expect(file.extension).to eq '.MP4'
        end
    end

    describe '.mv' do
        it 'moves the file to the specified path' do
            new_path = ::File.expand_path('fixtures/vid_two.mp4', ::File.dirname(__FILE__))
            # before
            expect(Peep::File.new(path).exists?).to eq true
            expect(Peep::File.new(new_path).exists?).to eq false
            expect(file.path).to eq path
            expect(file.name).to eq 'vid2.MP4'
            # move to new location (and rename)
            file.mv(new_path)
            # after
            expect(Peep::File.new(path).exists?).to eq false
            expect(Peep::File.new(new_path).exists?).to eq true
            expect(file.path).to eq new_path
            expect(file.name).to eq 'vid_two.mp4'
            # restore
            file.mv(path)
            # just like before
            expect(Peep::File.new(path).exists?).to eq true
            expect(Peep::File.new(new_path).exists?).to eq false
            expect(file.path).to eq path
            expect(file.name).to eq 'vid2.MP4'
        end
    end

    describe '.cd' do
        it 'moves the file to a specified relative folder' do
            new_path = ::File.expand_path('fixtures/Volumes/GOPRO3/vid2.MP4', ::File.dirname(__FILE__))
            # before
            expect(Peep::File.new(path).exists?).to eq true
            expect(Peep::File.new(new_path).exists?).to eq false
            expect(file.path).to eq path
            # move file two folders up
            file.cd('../..')
            # before
            expect(Peep::File.new(path).exists?).to eq false
            expect(Peep::File.new(new_path).exists?).to eq true
            expect(file.path).to eq new_path
            # restore
            file.cd('DCIM/100GOPRO')
            # just like before
            expect(Peep::File.new(path).exists?).to eq true
            expect(Peep::File.new(new_path).exists?).to eq false
            expect(file.path).to eq path
        end
    end
end
