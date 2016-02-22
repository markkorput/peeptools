require File.dirname(__FILE__) + '/spec_helper'

require 'peeptools/folder'

describe Peep::Folder do
    let(:folder){
        Peep::Folder.new('/Users/johndoe/Downloads')
    }

    describe '.initialize' do
        it 'accepts a single path string' do
           expect(Peep::Folder.new('/etc/apache2').name).to eq 'apache2'
        end
        
        it 'accepts a options hash' do
            expect(Peep::Folder.new(:path => '/etc/apache3').name).to eq 'apache3'
        end
    end
    
    describe '.path' do
        it 'defaults to current working directory' do
            expect(Peep::Folder.new.path).to eq Dir.pwd
        end
        
        it 'gives the path of the folder' do
            expect(folder.path).to eq '/Users/johndoe/Downloads'
        end
    end
    
    describe '.full_path' do
        it 'returns the folder\'s full path' do
            expect(Peep::Folder.new('fldr').full_path).to eq File.join(Dir.pwd, 'fldr')
        end
    end
    
    describe '.name' do
        it 'gives the names of the folder' do
            expect(folder.name).to eq 'Downloads'
        end
    end
    
    describe '.exists?' do
        it 'tells if .path exists' do
            expect(Peep::Folder.new('/z/zz/z/asdsasax').exists?).to eq false
            expect(Peep::Folder.new('/').exists?).to eq true
        end
    end
    
    describe '.folder' do
        it 'gives a specified child folder object' do
            expect(folder.folder('documents').class).to eq Peep::Folder
        end
        
        it "also gives folder objects that represent folders that don't exist" do
            expect(folder.folder('non_existing_child_adaEDDFWF').exists?).to eq false
        end
        
        it "gives a 'deep' offspring child folders as well" do
            expect(folder.folder('child/sub-child').path).to eq '/Users/johndoe/Downloads/child/sub-child'
        end
    end
    
    describe '.folders' do
        it 'gives all the child folders' do
            expect(folder.folders).to eq []
            expect(Dir).to receive(:glob).with('/Users/johndoe/Downloads/*').and_return(['/Users/johndoe/Downloads/a', '/Users/johndoe/Downloads/bb', '/Users/johndoe/Downloads/ccc'])
            expect(File).to receive(:directory?).with('/Users/johndoe/Downloads/a').and_return(true)
            expect(File).to receive(:directory?).with('/Users/johndoe/Downloads/bb').and_return(true)
            expect(File).to receive(:directory?).with('/Users/johndoe/Downloads/ccc').and_return(true)
            expect(folder.folders.map(&:name)).to eq ['a', 'bb', 'ccc']
        end
    end
    
    describe '[] operator' do
        it 'gives a specified child folder object' do
            expect(folder[:documents].class).to eq Peep::Folder
        end
        
        it "also gives folder objects that represent folders that don't exist" do
            expect(folder['non_existing_child_adaEDDFWF'].exists?).to eq false
        end
        
        it "gives a 'deep' offspring child folders as well" do
            expect(folder['child/sub-child'].path).to eq '/Users/johndoe/Downloads/child/sub-child'
        end
    end
    
    describe '.logger' do
        it 'gives the logger provided through the :logger option' do
            expect(Peep::Folder.new(:logger => :dummy).logger).to eq :dummy
        end
        
        it 'creates it own logger when no logger is provided' do
            expect(Peep::Folder.new.logger.class).to eq Logger
        end
    end
end
