<?php

// Database Variables
	$archived_posts_table_name = '';
	$approved_posts_table_name = '';
	$posts_table_name = '';

// Create connection
$con=mysqli_connect("host_name","user_name","password","database_name");

// Check connection
if (mysqli_connect_errno())
{
  echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

// Change character set to utf8
$con -> set_charset("utf8");

// This SQL statement selects all posts that haven't yet been evaluated
$sql = "SELECT id, title, postID, url, created, user FROM `".$posts_table_name."` WHERE postID NOT IN (SELECT postID FROM `".$approved_posts_table_name."`) AND postID NOT IN (SELECT postID FROM `".$archived_posts_table_name."`)";
 
// Check if there are results
if ($result = mysqli_query($con, $sql))
{
	$resultArray = array();
	$tempArray = array();
 
	// Loop through each row in the result set
	while($row = $result->fetch_object())
	{
		// Add each row into our results array
		$tempArray = $row;
	    array_push($resultArray, $tempArray);
	}
 
	// Encode array to JSON
	echo json_encode($resultArray);
}
 
// Close connections
mysqli_close($con);
?>
