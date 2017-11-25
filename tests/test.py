import json
import sys

try:
    import urllib.request as urlrequest
except ImportError:
    import urllib as urlrequest

SEARCH_STR = 'Flask Github Jobs'

data = json.load(open('test.json'))
app_port = data['app_port']
app_url = 'http://localhost:{}'.format(app_port)

result = str(urlrequest.urlopen(app_url).read())

if not SEARCH_STR in result:
    print("cound not find {} in response".format(SEARCH_STR))
    sys.exit(2)
