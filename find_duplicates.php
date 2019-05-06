<?php

$arguments = count($argv);

if ($arguments == 1){
	die("Usage: Please specify a folder to scan for duplicates.\n\n");
} else {
	$source_folder = $argv[1];
}
$formats = array("jpg", "tif", "tiff", "psd", "pdf");

if ( ! file_exists($argv[1])){
	$folder = $argv[1];
	$errorstring = "Specified folder $folder not found!\n\n";
    die($errorstring);
}

echo "\nGenerating hashes for files in $source_folder\n";

$Directory = new RecursiveDirectoryIterator($source_folder);
$Iterator = new RecursiveIteratorIterator($Directory);
$file_table = array();
$hashes = array();

foreach($formats as $format){
	$search_string = '/^.+\.' . $format . '$/i';
	$Regex = new RegexIterator($Iterator, $search_string, RecursiveRegexIterator::GET_MATCH);
	$fileindex = 0;
	foreach($Regex as $item){
		$fileindex += 1;
		$file_name = $item[0];
		#echo "Scanning " . $format . " [" . $fileindex . "] " . $file_name . "\n";
		$hash = md5_file($file_name);
		$entry = array();
		$entry['file_name'] = $file_name;
		$entry['hash'] = $hash;
		array_push($file_table, $entry);
		array_push($hashes, $hash);
	}
}

$uniques = array_unique($hashes);

echo count($hashes) . " Files hashed, " . count($uniques) . " unique files found.\n\n";

if (count($hashes) - count($uniques) > 0){

	echo "Duplicate report:\n";

	$counts = array_count_values($hashes);

	foreach ($counts as $key => $value){
		if($value > 1){
			$dupes_list = array();
			foreach($file_table as $entry){
				if($entry['hash'] == $key){
					array_push($dupes_list, $entry['file_name']);
					$name = basename($entry['file_name']);
				}
			} 	
			echo "\n" . $name . " occurs " . $value . " times:\n";
			$dupe_no = 0;
			foreach($dupes_list as $dupe){
				$dupe_no++;
				echo $dupe_no . ": " . $dupe . "\n";
			}
		}
	}
} else {
	echo "No duplicates found.\n\n";
}


?>