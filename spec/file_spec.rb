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

    describe '.cd' do
        it 'moves the file to a specfied folder'
    end
end
