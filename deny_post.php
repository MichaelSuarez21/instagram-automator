<?php
// `wrd` is just a "secret" word that helps make it so that this script is only ran when the variable is set to the correct phrase
	$wrd = $_POST["wrd"];
	if ("fjowiejfo584829jdj" != $wrd) {
		echo "no";
		exit;
	} 
	
// Database Variables
	$archived_posts_table_name = '';
	$posts_table_name = '';
	$postID = $_POST['postID'];
	
// Create connection
	$mysqli=mysqli_connect("host_name","user_name","password","database_name");
 
// Check connection
	if (mysqli_connect_errno()) {
	  echo "Failed to connect to MySQL: " . mysqli_connect_error();
	}

// Change character set to utf8
    $mysqli -> set_charset("utf8");

// Insert into posts that cannot be approved/grabbed again
	$query = "insert into `".$archived_posts_table_name."` (postID) value ('$postID')";
	$result = mysqli_query($mysqli,$query);

// Delete post from posts table
	$query = "delete from `".$posts_table_name."` where (postID) = ('$postID')";
	$result = mysqli_query($mysqli,$query);

	echo $result; // sends 1 if insert worked

	$conn->close();
?>