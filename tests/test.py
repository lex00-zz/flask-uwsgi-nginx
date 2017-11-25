#!/usr/bin/python
import json
import sys
import os

# CHANGE TO SCRIPT DIR
abspath = os.path.abspath(__file__)
script_dir = os.path.dirname(abspath)
os.chdir(script_dir)

# SAFE IMPORT FOR URL LIB
try:
    import urllib.request as urlrequest
except ImportError:
    import urllib as urlrequest

# TEST APP

SEARCH_STR = 'Flask Github Jobs'

data = json.load(open('test.json'))
app_port = data['app_port']
app_url = 'http://localhost:{}'.format(app_port)

result = str(urlrequest.urlopen(app_url).read())

if not SEARCH_STR in result:
    print("could not find {} in response".format(SEARCH_STR))
    sys.exit(2)
