# Peeptools

[![Build Status](https://travis-ci.org/markkorput/peeptools.svg)](https://travis-ci.org/markkorput/peeptools)

This gem contains a couple of ruby classes and invokable command-line scripts to automate some of the manual data-handling tasks when dealing with a multi-gopro camera setup (specifically designed for VR projects).
 
# 6-GoPro VR Workflow

#### Assumptions

Note that this workflow is not (yet) designed to be general purpose. Instead it is designed specifically for a six-gopro camera
setup. It assumes that;

* each gopro microSD card has the same name with a 1-6 digit postfix (like; GOPRO1, GOPRO2, ..., GOPRO6) to identify which camera the data comes from.
* data is transfered one microSD card at a time (it will probably give errors -or worse- when multiple sd cards are mounted simultaneously) 
* each 'take' should go in a separate folder that will have cam1.MP4, cam2.mp4 ..., cam6.MP4 files.

#### Steps

(run commands from a terminal from the root-folder of the peeptools repository)

##### Import

* Insert single microSD reader
* run ```./bin/peepimport.rb volume```
  * verify that it finds the appropriate volume/folder
* run ```./bin/peepimport.rb import```
  * this creates an _IMPORT folder in your current directory and populates it with the imported footage, inside a subfolder with the same name as the GoPro sd card
* (optional) when an import is finished, remove the the footage from the SD-card
* repeat for all (6) sd-cards

##### Organise

* In the current folder (which should now have an _IMPORT folder with all the imported footage) create a folder with the name ORGANISED (run ```mkdir ORGANISED```)
* Inside the ORGANISED folder create an empty index-prefixed folder for each take in the just imported footage.
  * So if you just imported three MP4 files from each camera, where the first two represent take1 and take2 from shot3 and the third represents take1 from shot4 (feel free to use more semantical names) you'd create folders like below (the 0X- prefix is important because it orders the folder so the footage ends up in the right folder);
    * 01-Shot3Take1
    * 02-Shot3Take2
    * 03-Shot4Take1
* run ```./bin/peepimport.rb amounts``` to verify that each camera folder in _IMPORT has exactly the number of files as the number of folders you've created in ORGANISED.
  * If this is not the case you've might have created an extra accidental take on one/some of the cameras (find it and remove it) or something else went wrong. Resolve it. Looking at the file sizes and timestamps can help figure out which files should be removed/are missing.
* run ```./bin/peepimport.rb organise``` to move all the footage from _IMPORT into the ORGANISED sub-folders.
* do a quick manual verification if the results make sense
  * all _IMPORT subfolders should be empty
  * all ORGANISED subfolders should have six *.MP4 files
* run ```./bin/peepimport.rb clean``` to rename all MP4 files to the camX.mp4 format
* (optional) run ```./bin/peepimport.rb unindex``` to remove the index prefix from all folders in the ORGANISED folder

##### Happy Stitchin'

Your ORGANISED folder now contains a folder for each take with a cam1.MP4, cam2.MP4, cam3.MP4, cam4.MP4, cam5.MP4 and cam6.MP4 file in it. This allows you to drop in a template stitching project file into each of those folders (I'm using Autopano video Pro so I'll drop in my .kava file from another stitch with the same camera setup. I'll sync the footage on audio and render an initial draft stitch without having to do any custom stiching for this take)



