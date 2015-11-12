#!./bin/python3.4

import sys
sys.path.insert(0, '/Library/Frameworks/Python.framework/Versions/3.4/lib/python3.4/site-packages/')

from scraper import Scraper

scraper = Scraper('https://ninjacourses.com/explore/4/')

print(scraper.getDepts())