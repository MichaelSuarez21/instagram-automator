#! python3
import mysql.connector
import praw
import datetime as dt

#Database Variables
postsTableName = ''
blackListedPostsTableName = ''
archivedPostsTableName = ''

#Re-format the dates so we can read them
def get_date(created):
    return dt.datetime.fromtimestamp(created)

#Establish Reddit user and developer credentials to access API
reddit = praw.Reddit(client_id='your_reddit_client_id_here',
                     client_secret='your_reddit_secret_id_here',
                     user_agent='user_agent',
                     username='your_reddit_username',
                     password='your_reddit_password')

#Select specific subreddit to crawl
subreddit = reddit.subreddit('Name_of_subreddit_to_scrape')

#Pull data for the top 200 posts of the selected subreddit for that week
top_subreddit = subreddit.top("week", limit=200)

#Define configuration for mysql database
config = {
    'user': 'username',
    'password': 'password',
    'host': 'host',
    'database': 'database_name',
    'raise_on_warnings': True,
    'charset': "utf8mb4", #Includes emojis
    'collation': "utf8mb4_general_ci"
}

#Connect to mysql database
cnx = mysql.connector.connect(**config)
mycursor = cnx.cursor()

#Clear our mha_posts to grab ones from current week
sql = "TRUNCATE TABLE " + postsTableName
mycursor.execute(sql)
cnx.commit()

#Grab list of blacklisted users
blacklisted = []
postDataSQL = "SELECT username FROM " + blackListedPostsTableName
mycursor.execute(postDataSQL)
records = mycursor.fetchall()
for row in records:
    blacklisted.append(row[0])

#Grab data for previously archived posts
archivedPosts = []
postDataSQL = "SELECT postID FROM " + archivedPostsTableName
mycursor.execute(postDataSQL)
records = mycursor.fetchall()
for row in records:
    archivedPosts.append(row[0])

#Insert post data into mysql database.
#Ensure that posts inserted don't already exist in array and are either .jpg or .png format, and not NSFW
sql = "INSERT INTO " + postsTableName + " (title, score, postID, url, body, created, user) VALUES (%s, %s, %s, %s, %s, %s, %s)"
for submission in top_subreddit:
    date = get_date(submission.created)
    if (str(submission.id) not in archivedPosts) and ((str(submission.url)[-3:] == "jpg" or str(submission.url)[-3:] == "png")) and not submission.over_18 and str(submission.author) not in blacklisted:
        val = (str(submission.title), submission.score, str(submission.id), str(submission.url), str(submission.selftext), str(date), str(submission.author))
        mycursor.execute(sql, val)
        cnx.commit()

cnx.close()
