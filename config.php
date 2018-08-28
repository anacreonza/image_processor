<?php
// Settings for Image conversion script.

// Path to ImageMagick convert executable for image format conversion

if (PHP_OS === "WINNT"){
    $path_string = "c:\Program Files\ImageMagick-7.0.8-Q16\Magick.exe";
} else {
    $path_string = "/usr/local/bin/convert";
}
$escaped_path_string = escapeshellarg($path_string);
define("CONVERT", $escaped_path_string);

// Path to Exiftool executable for metadata tagging
if (PHP_OS == "WINNT"){
    $path_string = 'c:\Program Files\exiftool.exe';
} else {
    $path_string = '/usr/local/bin/exiftool';
}
$escaped_path_string = escapeshellarg($path_string);
define("EXIFTOOL", $escaped_path_string);

// Images working folder:
if (PHP_OS == "WINNT"){
    define("WK_DIR", "c:\SmartMover temp"); # No trailing slash
} else {
    define("WK_DIR", "/SmartMover temp"); # No trailing slash
}

// Define minimum size (in bytes) of image file worth archiving
define("MINSIZE", 100000); # 100000 bytes is 100kb.


?>