# instagram-automator

## Basic Description
"instagram-automator" is a collection of several files that work across multiple platforms to automate the process of running theme/content pages on Instagram. Once configured, this process automates content collection for you to the point where you only need to spend 5 minutes a week browsing Reddit, via your iPhone app, to select posts for your page (and browsing Reddit isn't much of a chore).

## How it works, another basic description
We utilize Reddit's Python API Wrapper (PRAW) to grab post data from any specified subreddit(s). We store this data in a SQL database on a Linux server that is used to host your website. We then use an iPhone app to view and edit the posts via PHP scripts hosted on your website, select which posts we want to have posted to our own Instagram theme page, and deny those we do not. The ones we approve/deny will be updated/reflected in our database, which will then indicate to another Python script which posts will have its data used to generate RSS feed items to, which is then used by your Instagram uploading platform of choice to upload to your Instagram (I used [SocialBu.com](https://socialbu.com) for this, they are great and their developers are helpful, but there are many others that utilize RSS feeds as well). Cron jobs set up on your server will leave the content scraping / XML feed generating parts fully automated, leaving you only needing to approve which posts you want on your Instagram.

In short, posts go from: Reddit -> database -> iphone app -> database(approved/edited posts) -> RSS feed -> your Instagram

## Credits
The code used for the HomeModel.swift, PostModel.swift, and some of the ViewController.swift came from a [CodeWithChris.com](https://codewithchris.com/) tutorial (found [here](https://codewithchris.com/iphone-app-connect-to-mysql-database/)) and was modified to meet my needs.

I also recommend crediting the Reddit user who made the original post :) The iPhone app formats the 

## Setup
To set this up so you can use these files yourself for your own page, you must follow these steps:
* Either pay to host a server or host one yourself (I used a shared server on [Dreamhost.com](https://dreamhost.com), they are cheap and simple to use).
* Find a service like [SocialBu.com](https://socialbu.com) that utilizes RSS Feeds to automate posting to Instagram. Sign up with them and set up your Instagram account.
* Create a SQL database with a few simple tables to store the data for posts that will be posted to your Instagram ([Dreamhost.com](https://dreamhost.com) has MySQL setup on their shared servers by default, so this is what I used).
* Download each of the Python files and personalize them to your website's/subreddit's/Instagram page's/databases' needs.
* Download each of the Swift files and personalize them to your website's/subreddit's/Instagram page's/databases' needs. A section below will also describe how the StoryBoard for my application was created.
* Create at least 2 cron jobs to automate the process of grabbing Reddit data and updating the XML/RSS Feed files. Once these are automated, the only intervention needed by you is to approve posts on the iPhone app.

## List of Files and their purposes

### PHP FILES (on your web server)
* grab_posts: This file displays relevant post data encoded in JSON, pulled from your SQL database. This is useful to your iPhone app that will grab this data and display it to you.
* deny_post: This is the PHP script that is invoked whenever you click the "Deny" button on your iPhone app. It deletes the selected post from the general posts table and inserts it into the archived posts table.
* approve_post: This is the PHP script that is invoked whenever you click the "Approve" button on your iPhone app. It deletes the selected post from the general posts table and inserts it into the approved posts table. Approved posts will be used to generate RSS Feed items to ultimately be posted on your Instagram.

### PYTHON FILES (on your web server)
* redditScraper: Simply grabs the data for all the top posts from whichever subreddit is specified. This script will then insert all of this post data into your SQL table.
* redditDownload: Completely optional script for downloading the image files onto your server/machine.
* rssFeedGen: Initiates the RSS Feed for an Instagram page and grabs one post from your approved posts table. Once the feed has been created, the addFeedItem.py file will be used to add subsequent posts.
* addFeedItem: Grabs a post from your approved posts table and adds it to your RSS Feed.

### SWIFT FILES, at least the revelant ones (for your iPhone App)
* HomeModel: Used to create the class that pulls your JSON data from your SQL Database/PHP script, and then displays it to you via your Scroll View.
* PostModel: Used to create the class that stores the post data.
* ViewController: Set up to connect the data/models to your interface so that you can view/interact with the data.

### .zip Folder
Reddit-Approver.zip: Compressed folder of the iPhone application used to view/edit/approve/deny posts.

## Setting up your SQL Database
Here is a list of tables necessary to create:
* Posts table: Used to store all of the post data scraped from Reddit.
* Approved Posts table: Used to mark which posts have been approved and are ready to be posted.
* Archived Posts table: Used to mark which posts have been denied or have been approved and then posted already.

Optional table:
* Blacklisted users: A table used to avoid grabbing content from specific users.

Basic Format for each table:
* title - VARCHAR(200) // Post Title
* score - INT(10)      // Karma score for each post
* postID - INT(10)     // The unique identifier that Reddit associates with each post
* url - VARCHAR(100)   // url of the post's image
* body - TEXT          // Text associated with the post
* created - DATETIME   // Date of when post was created
* user - VARCHAR(50)   // Name of Reddit user who made the post

^ Each value for the data sizes are not solid, and can be moved up or down depending on your needs.

## Setting up your iPhone Application
The iPhone application is a simple, bare-bones app used to view, update, and approve/deny which posts will be used for your Instagram page. To create this application, you can either utilize the individual files in the SWIFT files folder and then create your own interface, or you can just download the .zip file to use my project directly. In regards to the $99 yearly cost Apple Developer Program: for our purposes, we are not uploading this app onto the App Store, so we don't need this membership. However, if you're not a part of the program, you will need to re-run your app from Xcode onto your phone (using it as a simulator) once every 10 days. This is slightly tedious to do, but if you do not do so then the app will be rendered un-usable after this time frame (in the case you're not a member of their program). It is only a small inconvenience and since I'm usually not too far from my laptop, it's not an issue.
