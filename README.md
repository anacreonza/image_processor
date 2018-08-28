# Archiving Scripts for Media24 images

This PHP script processes the images downloaded from Woodwing Enterprise by a Smart Mover job.

1. All images are copied out of the folders.
2. TIFF, PSD and BMP images are converted to JPEG, JPEG images are unchanged.
3. The colour space is not converted.
4. Images containing copyright symbols in the "Rights/Restrictions" metadata field are not archived.
5. Images with certain forbidden filenames (mostly filenames known to be used by syndication services) are not archived.
6. Images below a certain size (specified in config.php) will not be archived.
7. The images are then stored in an output folder, in a structure based on year/issue date. This is to prevent too many images being stored in the same folder.

The script requires that PHP, ExifTool and ImageMagick all be already installed on the target machine.

The locations of the ExifTool and ImageMagick executables are defined in the config.php file.

Start the script by running ```php ./prepare_images_for_fotoweb.php```
