from flask import Flask, Response, request, render_template
import requests
import hashlib
import redis

app = Flask(__name__)
cache = redis.StrictRedis(host='redis', port=6379, db=0)

default_name = 'Joe Bloggs'
salt = "UNIQUE_SALT"


@app.route('/', methods=['GET', 'POST'])
def mainpage():
    name = default_name

    if request.method == 'POST':
        name = request.form['name']
    salted_name = salt + name

    name_hash = hashlib.sha256(salted_name.encode()).hexdigest()

    return render_template('index.html', name=name, name_hash=name_hash)


@app.route('/monster/<name>')
def get_identicon(name):

    image = cache.get(name)
    if not image:
        print("Image was not cached", flush=True)
        r = requests.get('http://dnmonster:8080/monster/' + name + '?size=80')
        image = r.content
        cache.set(name, image)

    return Response(image, mimetype='image/png')

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')

