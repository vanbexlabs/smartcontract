from bottle import route, run, template
import os

@route('/')
def index():
    return open('./btb_log.txt').readlines()

run(host='0.0.0.0', port=os.environ['PORT'])
