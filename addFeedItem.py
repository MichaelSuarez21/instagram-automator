from feedgen.feed import FeedGenerator
from PIL import ImageFile
import time
import sys
import urllib.request
import mysql.connector
import xml.etree.ElementTree

#Database Variables
approvedPostsTableName = ''

#Getting time data for pubdate attribute
dayOfWeek = time.strftime("%a")
dayOfMonth = time.strftime("%d")
monthAbbr = time.strftime("%b")
year = time.strftime("%Y")
now = time.strftime("%H:%M:%S")
pubDateString = dayOfWeek + ", " + dayOfMonth + " " + monthAbbr + " " + year + " " + now + " PST"

#Function to retrieve file size from image
def getsizes(uri):
	with urllib.request.urlopen(uri) as file:
		size = file.headers.get("content-length")
		if size:
			size = int(size)
		p = ImageFile.Parser()
		while True:
			data = file.read(1024)
			if not data:
				break
			p.feed(data)
			if p.image:
				return size, p.image.size
				break
		file.close()
		return(size, None)

#Grab filename from command line argument and create etree object for parsing and editing
fileName = str(sys.argv[1])
et = xml.etree.ElementTree.parse("/path/to/xml/folder/" + fileName+'.xml')
root = et.getroot()

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
postText = ""
postImage = ""

#Grab the top post
sql = "SELECT postText, postImage, postID FROM " + approvedPostsTableName + " LIMIT 1"
mycursor.execute(sql)
records = mycursor.fetchall()


if (mycursor.rowcount == 0):
	print("Empty set. Cannot add post")
	quit()

for row in records:
    postText = row[0]
    postImage = row[1]
    postID = row[2]

#If the post was deleted, the next line will error out with HTTPError: HTTP Error 404: Not Found
imageSizeValue = str(getsizes(postImage))
imageSizeValue = imageSizeValue.replace('(', '')
imageSizeValue = imageSizeValue.replace(',', '')
imageSizeValueList = imageSizeValue.split(" ")

#Add new item element and add subelements
channel_item = root.find('channel')
new_item_element = xml.etree.ElementTree.SubElement(channel_item, "item")
new_title_element = xml.etree.ElementTree.SubElement(new_item_element, "title")
new_link_element = xml.etree.ElementTree.SubElement(new_item_element, "link")
new_description_element = xml.etree.ElementTree.SubElement(new_item_element, "description")
new_pubdate_element = xml.etree.ElementTree.SubElement(new_item_element, "pubDate")
new_guid_element = xml.etree.ElementTree.SubElement(new_item_element, "guid")
new_enclosure_element = xml.etree.ElementTree.SubElement(new_item_element, "enclosure")

#Add text for subelements
new_title_element.text = postText
new_link_element.text = postImage
new_description_element.text = postID 
new_pubdate_element.text = pubDateString
new_guid_element.text = "meditationfly.com " + postID

#Add attribute for subelement
new_guid_element.set("isPermaLink", "false")
new_enclosure_element.set("url", postImage)
new_enclosure_element.set("type", "image/" + postImage[-3:])
new_enclosure_element.set("length", imageSizeValueList[0])

et.write("/path/to/xml/folder/" + fileName + ".xml")

#Delete data from approved_posts table
sql = "DELETE FROM " + approvedPostsTableName + " WHERE postID = %s"
data = (str(postID),)
mycursor.execute(sql, data)
cnx.commit()
cnx.close()