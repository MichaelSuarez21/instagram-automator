#This file requires a few command line arguments:
# 1. The file name for the feed file that will be used (one feed file per account).
# 2. Title for the xml file generated.

import sys
import pytz
import datetime
from feedgen.feed import FeedGenerator

#create timezone variable
utc_now = pytz.utc.localize(datetime.datetime.utcnow())
pst_now = utc_now.astimezone(pytz.timezone("America/Los_Angeles"))

fileName = str(sys.argv[1])

fg = FeedGenerator()
fg.id('path/to/xml/folder' + fileName + '.xml')
fg.title(fileName+".xml")
fg.link( href='your_website_url_here', rel='alternate' )
fg.language('en')
fg.description("Feed for " + fileName + ".xml")

fg.rss_file('xml/' + fileName + '.xml')
