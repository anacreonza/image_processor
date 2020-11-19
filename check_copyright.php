<?php

require_once("config.php");

function check_rights($file, $excluded_names){
    
    $command_string = EXIFTOOL . " " . escapeshellarg($file);
    
    exec($command_string, $output);
    
    foreach ($output as $string){
    
        if (stripos($string, "Rights") !== false){
            $pos = stripos($string, ": ");
            $copyright_string = substr($string, $pos + 1);
            if (stripos($copyright_string, "media24")){
                return false;
            };
            foreach ($excluded_names as $name) {
	            if (stripos($string, $name)) {
   	    	        return $copyright_string;
    	        }
            }
        }
        if (stripos($string, "Copyright                       :") !== false){
        	$pos = stripos($string, ": ");
            $copyright_string = substr($string, $pos + 1);
            if (stripos($copyright_string, "media24")){
                return false;
            };
            foreach ($excluded_names as $name) {
	            if (stripos($string, $name)) {
   	    	        return $copyright_string;
    	        }
            }
        }
    }
}

$file = $argv[1];

$rights = check_rights($file, $excluded_names);

echo "Copyright claim:" . $rights . "\n";

?>