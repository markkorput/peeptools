# import_session = ImportSession.new
# while true
#   import_session.update
# end
#
# ---
#
# # keep looking/waiting for new volumes to import until the user aborts
# def update
#   # get all GoPro volumes we can find
#   folders = volume_finder # Peep::VolumeFinder.new(:logger => logger).folders
#
#   # deal with each found GoPro folder
#   folders.each do |folder|
#     # Create an importer for the GoPro folder
#     importer = importer(folder) # Peep::Importer.new(:folder => folder, :logger => logger)
#
#     # only process GoPro volumes if the target folder doesn't already exist
#     if !importer.target_folder.exists?
#       # ask user confirmation if necessary
#       if require_import_confirmation? != true || request_import_confirmation == true
#         # perform import
#         importer.import
#       end
#     end
#   end
# end
#
#   
