#!/usr/bin/python

import fileinput
import simplejson as json

def debug(log):
    if False:
        print log

headers = {}
j = {}

for line in fileinput.input():
    debug('loading json')
    j = json.loads(line)
    for key in j.keys():
        try:
            debug("found %s header again" % key)
            headers[key] += 1
        except KeyError:
            debug("adding %s header" % key)
            headers[key] = 1

print json.dumps(headers)
