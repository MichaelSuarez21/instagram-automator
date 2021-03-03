<?php
// `wrd` is just a "secret" word that helps make it so that this script is only ran when the variable is set to the correct phrase
	$wrd = $_POST["wrd"];
	if ("fjowiejfo584829jdj" != $wrd) {
		echo "no";
		exit;
	} 
	
// Database Variables
	$archived_posts_table_name = '';
	$approved_posts_table_name = '';
	$posts_table_name = '';

	$postID = $_POST['postID'];
	$postDescription = $_POST['postDescription'];
	$postURL = $_POST['postURL'];
	
// Create connection
$mysqli=mysqli_connect("host_name","user_name","password","database_name");
 
// Check connection
	if (mysqli_connect_errno()) {
	  echo "Failed to connect to MySQL: " . mysqli_connect_error();
	}

// Change character set to utf8
    $mysqli -> set_charset("utf8");

// Insert into posts to be made
	$query = "insert into `".$approved_posts_table_name."` (postID, postText, postImage) value ('$postID', '$postDescription', '$postURL')";
	$result = mysqli_query($mysqli,$query);

// Insert into posts that cannot be approved/grabbed again
	$query = "insert into `".$archived_posts_table_name."` (postID) value ('$postID')";
	$result = mysqli_query($mysqli,$query);

// Delete post from mha_posts
	$query = "delete from `".$posts_table_name."` where (postID) = ('$postID')";
	$result = mysqli_query($mysqli,$query);

	echo $result; // sends 1 if insert worked

	$conn->close();
?>