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
        it 'gives a GoproFolder instance' do
            expect(importer.source_folder.class).to eq Peep::GoproFolder
        end

        it 'can be configured through the main initializer param' do
            expect(Peep::Importer.new('/aa/bb/c').source_folder.path).to eq '/aa/bb/c'
        end

        it 'can be configured through :folder option' do
            expect(Peep::Importer.new(:folder => '/some/path').source_folder.path).to eq '/some/path'
            expect(Peep::Importer.new(:folder => Peep::GoproFolder.new('/some/other/path')).source_folder.path).to eq '/some/other/path'
        end

        it 'defaults to nil' do
            expect(Peep::Importer.new.source_folder).to eq nil
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

    # describe '.imported_folders' do
    #     let(:import_path){
    #         ::File.expand_path('fixtures/IMPORT', ::File.dirname(__FILE__))
    #     }
    #
    #     let(:importer){
    #         Peep::Importer.new(:import_folder => import_path)
    #     }
    #
    #     it 'gives all folders in the import_folder' do
    #         expect(importer.imported_folders.map(&:name)).to eq ['GOPRO3']
    #     end
    # end

    # gives the folder inside the GoproFolder to which imported files will be moved
    describe '.mark_as_imported_folder' do
        it 'defaults to the DCIM/peepimport1 subfolder inside the GoproFolder' do
            expect(Peep::Importer.new(fixture_source_path).mark_as_imported_folder.path).to eq File.join(fixture_source_path, 'DCIM', 'peepimport1')
        end

        it 'will increase the trailing digit in order to use a previously non-existing folder' do
            importer = Peep::Importer.new(fixture_source_path)
            expect(importer.mark_as_imported_folder.path).to eq importer.source_folder['DCIM/peepimport1'].path
            importer.source_folder['DCIM/peepimport1'].create
            expect(importer.mark_as_imported_folder.path).to eq importer.source_folder['DCIM/peepimport2'].path
            importer.source_folder['DCIM/peepimport2'].create
            expect(importer.mark_as_imported_folder.path).to eq importer.source_folder['DCIM/peepimport3'].path
            importer.source_folder['DCIM/peepimport1'].remove
            expect(importer.mark_as_imported_folder.path).to eq importer.source_folder['DCIM/peepimport1'].path
            importer.source_folder['DCIM/peepimport2'].remove
        end
    end
end
