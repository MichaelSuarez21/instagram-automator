# instagram-automator

## Basic Description
"instagram-automator" is a collection of several files that work across multiple platforms to automate the process of running theme/content pages on Instagram. Once configured, this process automates content collection for you to the point where you only need to spend 5 minutes a week browsing Reddit, via your iPhone app, to select posts for your page (and browsing Reddit isn't much of a chore).

## How it works, another basic description
We utilize Reddit's Python API Wrapper (PRAW) to grab post data from any specified subreddit(s). We store this data in a SQL database on a Linux server that is used to host your website. We then use an iPhone app to access this data via PHP scripts hosted on your website, select which posts we want to have posted to our own Instagram theme page, and disapprove of those we do not. The ones we approve/disapprove of will be updated/reflected in our database, which will then indicate to another Python script which posts will have its data used to generate RSS feed items to, which is then used by your Instagram uploading platform of choice (I used [SocialBu.com](https://socialbu.com) for this, they are great, but there are many others that utilize RSS feeds) to upload to your Instagram. Cron jobs set up on your server will leave the content scraping / XML feed generating parts fully automated- you just need to approve which posts you want.

In short, posts go from: Reddit -> database -> iphone app -> database(approved posts) -> RSS feed -> your Instagram

## Credits
The code used for the HomeModel.swift, PostModel.swift, and some of the ViewController.swift came from a [CodeWithChris.com](https://codewithchris.com/) tutorial (found [here](https://codewithchris.com/iphone-app-connect-to-mysql-database/)) and was modified to meet my needs.

## Setup
To set this up so you can use these files yourself for your own page, you must follow these steps:
* Either pay to host a server or host one yourself (I used a shared server on [Dreamhost.com](https://dreamhost.com), they are cheap and simple to use).
* Find a service like [Socialbu.com](https://socialbu.com) that utilizes RSS Feeds to automate posting to Instagram. Sign up with them and set up your Instagram account.
* Create a SQL database with a few simple tables to store the data for posts that will be posted to your Instagram.
* Download each of the Python files and personalize them to your website's/subreddit's/Instagram page's/databases' needs.
* Download each of the Swift files and personalize them to your website's/subreddit's/Instagram page's/databases' needs. A section below will also describe how the StoryBoard for my application was created.
* Create at least 2 cron jobs to automate the process of grabbing Reddit data and updating the XML/RSS Feed files. Once these are automated, the only intervention needed by you is to approve posts on the iPhone app.
