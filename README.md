# Cultural Ecosystem Services - Recreation Potential Model Version 2

More versatile version of the recreation potential model from uc-ces (https://github.com/BioDT/uc-ces/tree/main/recreation_model) with larger geograpic extent and custom personas. Developed by Chris Andrews.

The main RShiny App is called BioDT_RP_Scot_RShiny_app_Reduced_Model.R.  It won't run fully without access to the raster files which should be named according to, and located in, the correct model components input folders.  e.g. FIPS_I_Footpaths located in the FIPS_I folder.

Once a local version has been established, edit the filepath to the "home_folder" (parent folder for repository) in the main script.

The model is designed to accept a set of user defined values to reclassify raster datasets within each of the four components.
1. SLSRA - Landscape features that support recreational activities
2. FIPS_N - Natural features that support recreational activities
3. FIPS_I - Infrastructure features that support recreational activities
4. Water - Water features that support recreational activities

Because water and infrastructure are considered very important in recreation, scores are also graded based on proximity to the feature in question.

The model allows for the uploading of of a shapefile within the geographic exent of Scotland, or selecting from a pre-existing list of shapefiles.  Once a new shapefile is uploaded it can then be selected from the existing list.  The user then creates a persona and scores the feature attributes relevent to their recreational needs, or can select from an existing persona list.  When submitted personas are saved to an output folder, and can be called and edited from the existing list thereafter.  User scores can be exported as a .csv from within the app once submitted, and are called by the model for reclassifying rasters when the model is run.
