require 'logger'

module Peep
  module Folders

    def logger
      @logger ||= options[:logger] || Logger.new(STDOUT).tap do |l|
        l.level = Logger::DEBUG
      end
    end

    def config
      defined?(CONFIG) ? CONFIG : {}
    end

    def project_volume
      config[:project_volume] || '/Volumes/PEEPDISK1'
    end

    def project_folder
      config[:project_folder] || project_volume
    end

    def layers_folder
      config[:layers_folder] || File.join(project_folder, '01-LAGEN')
    end

    def layer_folders
      Dir.glob(File.join(layers_folder, '*')).select{|f| File.directory?(f)}.to_a.map{|f| LayerFolder.new(:folder => f)}
    end

    alias :layers_folders :layer_folders

    def stitches_folder
      config[:layers_folder] || File.join(project_folder, '02-STITCHED')
    end

    def stitch_template
      File.join(layers_folder, 'stitch-template.kava')
    end
  end

  class LayerFolder
    attr_accessor :options

    def initialize _opts = {}
      @options = _opts
    end

    def logger
      @logger ||= options[:logger] || Logger.new(STDOUT).tap do |l|
        l.level = Logger::DEBUG
      end
    end

    def folder
      options[:folder]
    end

    def files(pattern)
      Dir.glob(File.join(folder, pattern)).to_a
    end

    def kavas
      files('*.kava')
    end

    def mp4s
      files('*.mp4')
    end

    def movs
      files('*.mov')
    end

    def vids
      mp4s + movs
    end
  end

  class Linker
    include Peep::Folders

    attr_accessor :options

    def initialize _opts = {}
      @options = _opts
    end

    def layer_folder
      options[:folder] || options[:layer_folder]
    end

    def existing
      @existing ||= Dir.glob(File.join(stitches_folder, '*')).to_a
    end

    def existing_basenames
      existing.map{|x| File.basename(x)}
    end

    def link_vids
      layer_folder.vids.each{|v| link_vid(v)}
    end

    def link_vid vid, opts = {}
      full_name = "#{File.basename(layer_folder.folder)}-#{File.basename(vid)}"
      symlink = File.join(stitches_folder, full_name)
      target = vid

      return if existing_basenames.find{|x| x == full_name} && opts[:overwrite] != true 

      cmd = "ln -s \"#{target}\" #{symlink}"
      logger.info "Executing link: #{cmd}"
      `#{cmd}`
    end
  end
end

class Peeper
  include Peep::Folders

  attr_accessor :options

  def initialize _opts = {}
    @options = _opts
  end

  def logger
    @logger ||= options[:logger] || Logger.new(STDOUT).tap do |l|
      l.level = Logger::DEBUG
    end
  end

  def ln_stitches
    layer_folders.each do |lf|
      # logger.info "Linking stitches for #{lf.folder}"
      Peep::Linker.new(:folder => lf).link_vids
    end
  end

  def kavaall
    layer_folders.select{|lf| lf.kavas.empty?}.each do |lf|
      from = stitch_template
      to = File.join(lf.folder, 'stitcher.kava')
      cmd = "cp #{from} #{to}"
      logger.info "Executing: #{cmd}"
      `#{cmd}`
    end
  end
end
