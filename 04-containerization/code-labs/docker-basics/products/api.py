# product services

from flask import Flask
from flask_restful import Resource, Api

app = Flask(__name__)
api = Api(app)

class Product(Resource):
    def get(self):
        return {"products": ["laptop", "phone", "tablet", "monitor"]}
    
api.add_resource(Product, '/products')
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=80)