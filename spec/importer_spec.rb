require File.dirname(__FILE__) + '/spec_helper'

require 'peeptools/importer'

describe Peep::Importer do
    let(:fixture_path){
        ::File.expand_path('fixtures/GOPRO3', ::File.dirname(__FILE__))
    }

    let(:importer){
        Peep::Importer.new(fixture_path)
    }

    describe '.import_folder' do
        it 'defaults to the _IMPORT folder in the current working directory' do
            expect(Peep::Importer.new.import_folder.full_path).to eq ::File.join(Dir.pwd, '_IMPORT')
        end
    end

    describe '.target_folder' do
        it 'defaults to the volume folder name inside the import folder' do
            expect(importer.target_folder.full_path).to eq ::File.join(Dir.pwd, '_IMPORT', 'GOPRO3')
        end
    end
    
    describe '.source_folder' do
        it 'gives the specified folder' do
            expect(importer.source_folder.path).to eq fixture_path
        end
    end
    
    # describe '.import' do
    #     it "should import the video files" do
    #         expect(importer.import_folder.exists?).to eq false
    #         importer.import
    #         expect(importer.import_folder.exists?).to eq true
    #         expect(importer.import_folder[importer.source_folder.name].files.map(&:name)).to eq ['vid1.MP4', 'vid2.MP4', 'vid3.MP4']
    #         # cleanup
    #         importer.import_folder.remove(:force => true)
    #     end
    # end
end