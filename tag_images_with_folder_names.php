<?php

require_once('config.php');
$input_dir = $argv[1];

if (!isset($input_dir)){
    print_r("\nPlease specify a source folder of images to tag.");
    exit;
}

$format = "jpg";

$Directory = new RecursiveDirectoryIterator($input_dir);
$Iterator = new RecursiveIteratorIterator($Directory);
$file_extension = '/^.+\.' . $format . '$/i';
$Regex = new RegexIterator($Iterator, $file_extension, RecursiveRegexIterator::GET_MATCH);
$files = array();
foreach($Regex as $filepath){
	array_push($files, $filepath[0]);
}

foreach($files as $file){
    $dirname = dirname($file);
    $dirname = str_replace($input_dir, '' , $dirname);
    $dirnames = explode(DIRECTORY_SEPARATOR, $dirname);
    echo ("\n\nFilename: " . basename($file));
    foreach ($dirnames as $name){
        if ($name) {
            $name = escapeshellarg($name);
            echo "\nAdding tag: " . $name;
            $command_string = EXIFTOOL . " \"" . $file . "\" -ignoreMinorErrors -overwrite_original -keywords+=" . $name;
            #echo($command_string);
            exec($command_string, $output);
        }
    }
}


?>