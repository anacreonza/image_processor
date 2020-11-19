<?php
require_once('config.php');
$input_dir = $argv[1];

if (!isset($input_dir)){
    print_r("\nPlease specify a source folder of images to convert.");
    exit;
}

$formats = [
	'TIF',
	'TIFF',
	'PSD',
	"PNG",
	"BMP"
];

function compress_images($format, $input_dir){
	$Directory = new RecursiveDirectoryIterator($input_dir);
	$Iterator = new RecursiveIteratorIterator($Directory);
	$file_extension = '/^.+\.' . $format . '$/i';
	$Regex = new RegexIterator($Iterator, $file_extension, RecursiveRegexIterator::GET_MATCH);
	$files = array();
	foreach($Regex as $filepath){
		array_push($files, $filepath[0]);
	}
	foreach($files as $file){
		$old_filename = basename($file);
		$escaped_filename = escapeshellarg($file);
		print_r("\n\nOld file: " . $file);
		$path_parts = pathinfo($file);
		$new_jpeg = $path_parts['dirname'] . DIRECTORY_SEPARATOR . $path_parts['filename'] . ".jpg";
		$escaped_new_jpeg = escapeshellarg($new_jpeg);
		$dirname = $path_parts['dirname'];
		print_r("\nNew file: " . $new_jpeg . "\n");
		$command_string = CONVERT . " -flatten -quiet " . $escaped_filename . " " . $escaped_new_jpeg;
		#print_r("Executing: $command_string");
		exec($command_string, $output);
		if (file_exists($new_jpeg)){
			print_r("Deleting old file");
			unlink($file);
		}
	}

}

foreach ($formats as $format) {
	print_r("Processing $format files...\n");
	compress_images($format, $input_dir);
}

?>