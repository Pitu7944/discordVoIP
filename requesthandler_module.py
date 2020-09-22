from flask import Flask, request, abort
from config import Config
import json

app = Flask("RequestHandler")

@app.route('/moveMember', methods=['POST'])
def moveMember():
    if not request.json:
        abort(400)
    print(request.json)
    if request.json['api_key'] == Config.apikey:
        with open('queue.json','r') as f:
            move_queue = json.load(f)
        move_queue.append({'member_id': request.json['member_id'],'channel_id': request.json['channel_id']})
        with open('queue.json','w') as f:
            json.dump(move_queue, f, indent=4)
        return("Succes")
    else:
        abort(401)

app.run(debug=True, port=5137)