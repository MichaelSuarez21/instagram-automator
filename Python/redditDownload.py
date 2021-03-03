import requests
import mysql.connector
import os.path

#Database Variables
postsTableName = ''
blackListedPostsTableName = ''
archivedPostsTableName = ''

savePath = '/path/to/folder/for/downloaded/files/'
downloadedPostsTableName = ''

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

#Insert post data into mysql database
sqlSelect = "SELECT url, postID FROM " + postsTableName
mycursor = cnx.cursor()
mycursor.execute(sqlSelect)

#Create dictionaries & arrays that will store the data for new images and previously downloaded ones
linksAndImages = {}
alreadyDownloaded = []

#Store all of the urls+postIDs from mha_posts
records = mycursor.fetchall()
for row in records:
    linksAndImages[row[0]] = row[1]

#Create new select to grab postIDs for previously downloaded images
sqlSelect = "SELECT postID FROM " + downloadedPostsTableName
mycursor.execute(sqlSelect)

#Store all of the postIDs from mha_downloaded_images
records = mycursor.fetchall()
for row in records:
    alreadyDownloaded.append(row[0])

#Loop through the urls and postIDs from post table,
#if not in downloaded files table --> download it and add it to the table
for url, postID in linksAndImages.items():
    if postID not in alreadyDownloaded:
        response = requests.get(url)
        fileTypeString = url[-3:]
        fullFileName = os.path.join(savePath, postID+"."+fileTypeString)    #TEMPORARY SOLUTION: grab last 3 chars for file type
        file = open(fullFileName, 'wb')
        file.write(response.content)
        file.close()
        insertQuery = "INSERT INTO " + downloadedPostsTableName + " (postID, filePath) VALUES (%s, %s)"
        values = (postID, fullFileName)
        mycursor.execute(insertQuery, values)
        cnx.commit()

cnx.close()
