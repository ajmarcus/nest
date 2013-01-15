#!/usr/bin/python

import fileinput
import simplejson as json

fields = ['text': 330071, 'date': 330071, 'open': 13490, 'city': 13490, 'votes': 460944, 'user_id': 460944, 'state': 13490, 'stars': 343561, 'latitude': 13490, 'type': 474434, 'review_id': 330071, 'business_id': 343561, 'full_address': 13490, 'average_stars': 130873, 'schools': 13490, 'review_count': 144363, 'categories': 13490, 'photo_url': 13490, 'name': 144363, 'neighborhoods': 13490, 'url': 144363, 'longitude']


for line in fileinput.input():
    j = json.loads(line)
