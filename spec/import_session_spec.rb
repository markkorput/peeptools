require File.dirname(__FILE__) + '/spec_helper'

require 'peeptools/import_session'

describe Peep::ImportSession do
    let(:path_import_folder_fixture){
        File.expand_path('fixtures/IMPORT', File.dirname(__FILE__))
    }

    let(:path_volumes_folder_fixture){
        File.expand_path('fixtures/Volumes', File.dirname(__FILE__))
    }

    describe '.require_import_confirmation?' do
        it 'is true by default' do
          expect(Peep::ImportSession.new.require_import_confirmation?).to eq true
        end

        it 'can be configured through the :require_import_confirmation options' do
          expect(Peep::ImportSession.new(:require_import_confirmation => false).require_import_confirmation?).to eq false
          expect(Peep::ImportSession.new(:require_import_confirmation => true).require_import_confirmation?).to eq true
        end
    end

    describe '.request_import_confirmation' do
        it 'prompts the user for confirmation'
    end

    describe '.ejects?' do
      it 'is true by default' do
        expect(Peep::ImportSession.new.ejects?).to eq true
      end

      it 'can be set to false through the :eject option' do
        expect(Peep::ImportSession.new(:eject => false).ejects?).to eq false
      end
    end

    describe '.volume_finder' do
        it 'gives a VolumeFinder instance' do
            expect(Peep::ImportSession.new.volume_finder.class).to eq Peep::VolumeFinder
        end

        it 'gives a VolumeFinder who\'s volumes_folder can be configured through the :volumes_folder option' do
            expect(Peep::ImportSession.new(:volumes_folder => '/vol/umes').volume_finder.volumes_folder.path).to eq '/vol/umes'
        end
    end

    describe '.importer' do
        it 'takes a GoproFolder instance and gives an Importer instance with the given folder as source' do
            gopro_folder = Peep::GoproFolder.new('/Volumes/SomeGopro')
            imp = Peep::ImportSession.new.importer(gopro_folder)
            expect(imp.class).to eq Peep::Importer
            expect(imp.source_folder.path).to eq gopro_folder.path
        end

        it 'gives Importer instances who\'s import_folder can be configured through the import_folder option' do
            gopro_folder = Peep::GoproFolder.new('/Volumes/SomeGopro')
            imp = Peep::ImportSession.new(:import_folder => path_import_folder_fixture).importer(gopro_folder)
            expect(imp.import_folder.path).to eq path_import_folder_fixture
        end
    end

    describe '.update' do
        let(:import_folder){ Peep::Folder.new(path_import_folder_fixture) }
        let(:volumes_folder){ Peep::Folder.new(path_volumes_folder_fixture) }
        let(:import_session){
            Peep::ImportSession.new({
              :import_folder => import_folder.path,
              :volumes_folder => volumes_folder.path,
              :require_import_confirmation => false})
        }

        it 'auto-imports mounted GoproFolder video content' do
            # before
            expect(import_folder['GOPRO3'].exists?).to eq false
            expect(import_folder['GOPRO3'].files.map(&:name)).to eq []
            # execute
            import_session.update

            # verify
            expect(import_folder['GOPRO3'].files.map(&:name)).to eq ['vid1.MP4', 'vid2.MP4', 'vid3.MP4']
            # restore
            import_folder['GOPRO3'].remove(:force => true) # delete imported folder
            # return source fixture files back to their original folder
            volumes_folder['GOPRO3/DCIM/peepimport1'].files.each do |moved_file|
                moved_file.cd('../100GOPRO')
            end
            volumes_folder['GOPRO3/DCIM/peepimport1'].remove
        end

        it 'marks the imported content as imported by parking it in a peepimportX folder inside the GoproFolder/DCIM subfolder' do
          # before
          expect(volumes_folder['GOPRO3/DCIM/peepimport1'].exists?).to eq false
          expect(volumes_folder['GOPRO3/DCIM/100GOPRO'].files.map(&:name)).to eq ['vid1.MP4', 'vid2.MP4', 'vid3.MP4']
          # execute
          import_session.update
          # verify
          expect(volumes_folder['GOPRO3/DCIM/peepimport1'].files.map(&:name)).to eq ['vid1.MP4', 'vid2.MP4', 'vid3.MP4']
          expect(volumes_folder['GOPRO3/DCIM/100GOPRO'].files.map(&:name)).to eq []
          # restore
          import_folder['GOPRO3'].remove(:force => true) # delete imported folder
          # return source fixture files back to their original folder
          volumes_folder['GOPRO3/DCIM/peepimport1'].files.each do |moved_file|
              moved_file.cd('../100GOPRO')
          end
          volumes_folder['GOPRO3/DCIM/peepimport1'].remove
        end

        # it 'detects newly mounted GoPro volumes' do
        #     import_session =
        #
        #     import_session.update
        #
        #   # expect thread to be running
        #
        # end
    end
end
