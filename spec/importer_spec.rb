require File.dirname(__FILE__) + '/spec_helper'

require 'peeptools/importer'

describe Peep::Importer do
    let(:fixture_source_path){
        ::File.expand_path('fixtures/Volumes/GOPRO3', ::File.dirname(__FILE__))
    }

    let(:importer){
        Peep::Importer.new(fixture_source_path)
    }

    describe '.import_folder' do
        it 'defaults to the _IMPORT folder in the current working directory' do
            expect(Peep::Importer.new.import_folder.full_path).to eq ::File.join(Dir.pwd, '_IMPORT')
        end
        
        it 'can be configured through the :import_folder option' do
            expect(Peep::Importer.new(:import_folder => '/tmp/_imprt').import_folder.full_path).to eq '/tmp/_imprt'
        end
    end

    describe '.target_folder' do
        it 'defaults to the volume folder name inside the import folder' do
            expect(importer.target_folder.full_path).to eq ::File.join(Dir.pwd, '_IMPORT', 'GOPRO3')
        end
    end
    
    describe '.source_folder' do
        it 'gives the specified folder' do
            expect(importer.source_folder.path).to eq fixture_source_path
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
    
    describe '.imported_folders' do
        let(:import_path){
            ::File.expand_path('fixtures/_IMPORT', ::File.dirname(__FILE__))
        }

        let(:importer){
            Peep::Importer.new(:import_folder => import_path)
        }

        it 'gives all imported folders' do
            expect(importer.imported_folders.map(&:name)).to eq ['GOPRO3']
        end
    end
end
