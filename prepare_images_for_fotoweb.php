<?php

require_once("config.php");
error_reporting(0); # Suppress warning messages.



function remove_underscores($string){
	return str_replace("_", " ", $string);
}

function check_rights($file){
    
    $command_string = EXIFTOOL . " " . escapeshellarg($file);
    
    exec($command_string, $output);
    
    foreach ($output as $string){
    
        if (stripos($string, "Rights") !== false){
            $pos = stripos($string, ": ");
            $copyright_string = substr($string, $pos + 1);
            if (stripos($copyright_string, "media24")){
                return false;
            };
            if (stripos($string, "©")) {
                return $copyright_string . "\n";
            }
        }
    }
}

echo "\n";
echo "###################################\n";
echo "#                                 #\n";
echo "#  PHP Image Conversion Script.   #\n";
echo "#                                 #\n";
echo "###################################\n\n";

$brnd = $argv[1];
$brnd = strtoupper($brnd);

switch ($brnd){
	case "MV":
		$selected_brand = "Move";
		break;
	case "TV":
		$selected_brand = "TV Plus";
		break;
	case "FW":
		$selected_brand = "Finweek";
		break;
	case "YB":
		$selected_brand = "Your Baby";
		break;
	case "YP":
		$selected_brand = "Your Pregnancy";
		break;
	case "BK":
		$selected_brand = "Baba En Kleuter";
		break;
	case "TL":
		$selected_brand = "True Love";
		break;
	default:
		die("\nPlease specify a brand code from one of the following: Move(MV), TV Plus(TV), Finweek(FW), Your Baby(YB), Your Pregnancy(YP), Baba En Kleuter(BK) or True Love(TL).\n\n");

}

echo "Archiving files for $selected_brand\n\n";

$file_formats = [
	"JPG",
	"JPEG",
	"TIF",
	"TIFF",
	"PSD",
	"BMP"
];

function process_images($format, $selected_brand, $excluded_filenames){
	$input_dir = WK_DIR . DIRECTORY_SEPARATOR . $selected_brand . "Archive" . DIRECTORY_SEPARATOR . strtoupper(str_replace(" ", "", $selected_brand)) . DIRECTORY_SEPARATOR . "Archived" . DIRECTORY_SEPARATOR . "Print";
	$output_root = WK_DIR . DIRECTORY_SEPARATOR . "Images Done" . DIRECTORY_SEPARATOR . strtoupper(str_replace(" ", "", $selected_brand)); 
	$file_extension = '/^.+\.' . $format . '$/i';
	$Directory = new RecursiveDirectoryIterator($input_dir);
	$Iterator = new RecursiveIteratorIterator($Directory);
	$Regex = new RegexIterator($Iterator, $file_extension, RecursiveRegexIterator::GET_MATCH);
	$files = array();
	foreach($Regex as $filepath){
		array_push($files, $filepath[0]);
	}

	$filecount = count($files);

	if ($filecount == 0) {
		$errorstring = "No " . $format . "files found in " . WK_DIR . " !\n\n";
	}
	$progress_count = 1;
	foreach ($files as $filepath){
		$filename = basename($filepath);
		echo "Processing file $progress_count of $filecount $format files...\n\n";
		
		# Derive metadata from filesystem
		$image_path = str_replace($input_dir, "", $filepath);
		$basename = basename($filepath);
		echo "File Name: " . $basename . "\n";
		#echo "Image Path: " . $image_path . "\n";
		$dirname = dirname($image_path);
		$dirnames = explode(DIRECTORY_SEPARATOR, $dirname);
		$newfile = $output_dir . DIRECTORY_SEPARATOR . $basename;
		
		# Prepare destination folder structure
		$year = $dirnames[1];
		$year = substr($year, 4, 2);
		$year = "20" . $year;
		
		$month = $dirnames[1];
		$month = substr($month, 2, 2);
		
		$day = $dirnames[1];
		$day = substr($day, 0, 2);
		$output_dir = $output_root . DIRECTORY_SEPARATOR . $year . DIRECTORY_SEPARATOR . $month . $day;
		if ( ! file_exists($output_dir)){
			mkdir($output_dir, 0777, true);
		}
		# Check size of potential file to archive:
		$size = filesize($filepath);
		if ($size < MINSIZE){
			
			echo "Skipping file $filename because it's below the minimum size threshhold.\n\n";
			$progress_count++;
			continue;
		}
		# Check if file has a forbidden filename
		foreach($excluded_filenames as $string){
			if (stripos($filename, $string) !== false ){
				echo "Skipping forbidden file $filename.\n\n";
				$progress_count++;
				continue 2;
			}
		}
		# Check if file has forbidden metadata
		$rights = check_rights($filepath);
		if ($rights){
			echo "Skipping file for copyright claim: " . $rights . "\n\n";
			$progress_count++;
			continue;
		}

		# Duplicate file into new destination.
		#echo "Copying " . $filepath . " to " . $newfile;
		$escaped_name = escapeshellarg($newfile);
		copy($filepath, $newfile);
		$path_parts = pathinfo($newfile);
		$new_jpeg = $path_parts['filename'] . ".jpg";
		$new_jpeg = $output_dir . DIRECTORY_SEPARATOR . $new_jpeg;
		
		# Conversion loop
		if ( $newfile !== $new_jpeg){
			echo "Compressing file to JPEG...\n";
			$escaped_filename = escapeshellarg($newfile);
			$escaped_new_jpeg = escapeshellarg($new_jpeg);
			if (PHP_OS == "WINNT"){
				$command_string = CONVERT . " convert -flatten -quiet " . $escaped_filename . " " . $escaped_new_jpeg;
			} else {
				$command_string = CONVERT . " -flatten -quiet " . $escaped_filename . " " . $escaped_new_jpeg;
			}
			#echo "Running " . $command_string . "\n";
			exec($command_string, $output);
			unlink($newfile);
		}
		
		# Tagging loop
		foreach ($dirnames as $name){
			if ($name) {
				$name = escapeshellarg($name);
				#echo "Tagging " . $name . "\n";
				$name = remove_underscores($name);
				echo "Adding tag: " . $name . "\n";

				$command_string = EXIFTOOL . " " . $escaped_new_jpeg . " -ignoreMinorErrors -overwrite_original -keywords+=" . $name;
				#echo "Running " . $command_string . "\n";
				exec($command_string, $output);
			}
		}
		$progress_count++;
		echo "\n\n";
	}
}

foreach($file_formats as $format){
	process_images($format, $selected_brand, $excluded_filenames);
}



?>