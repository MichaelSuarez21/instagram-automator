# instagram-automator

##Basic Description
"instagram-automator" is a collection of several files that work across multiple platforms to automate the process of running theme/content pages on Instagram. Once configured, this process automates content collection for you to the point where you only need to spend 5 minutes a week, browsing Reddit, to select posts for your page (and browsing Reddit isn't much of a chore).

##How it works, another basic description
We utilize Reddit's Python API Wrapper (PRAW) to grab post data from any specified subreddit(s). We store this data in a SQL database on a Linux server that is used to host your website. We then use an iPhone app to access this data via PHP scripts hosted on your website, select which posts we want to have posted to our own Instagram theme page, and disapprove of those we do not. The ones we approve/disapprove of will be updated/reflected in our database, which will then indicate to another Python script which posts will have its data used to generate RSS feed items to, which is then used by your Instagram uploading platform of choice (I used SocialBu.com for this, they are great, but there are many others that utilize RSS feeds) to upload to your Instagram. Cron jobs set up on your server will leave the content scraping / XML feed generating parts fully automated- you just need to approve which posts you want.

In short, posts go from: Reddit -> database -> iphone app -> database(approved posts) -> RSS feed -> your Instagram

##Overview of Parts
*Remote Linux server hosting your website
*iPhone Application used for approving posts
