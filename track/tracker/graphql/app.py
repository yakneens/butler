#!/usr/bin/env python

from flask import Flask

from flask_cors import CORS
from flask_graphql import GraphQLView
from schema import schema

from flask_debugtoolbar import DebugToolbarExtension


import pprint

class LoggingMiddleware(object):
    def __init__(self, app):
        self._app = app

    def __call__(self, environ, resp):
        errorlog = environ['wsgi.errors']
        pprint.pprint(('REQUEST', environ), stream=errorlog)

        def log_response(status, headers, *args):
            pprint.pprint(('RESPONSE', status, headers), stream=errorlog)
            return resp(status, headers, *args)

        return self._app(environ, log_response)

app = Flask(__name__)

CORS(app)
app.debug = True

app.config['SECRET_KEY'] = 1337
toolbar = DebugToolbarExtension(app)

default_query = '''
{
  allEmployees {
    edges {
      node {
        id,
        name,
        department {
          id,
          name
        },
        role {
          id,
          name
        }
      }
    }
  }
}'''.strip()


app.add_url_rule('/graphql', view_func=GraphQLView.as_view('graphql', schema=schema, graphiql=True))
def graphql():
    str = pprint.pformat(request.environ, depth=5)
    return Response(str, mimetype="text/text")

if __name__ == '__main__':
    app.wsgi_app = LoggingMiddleware(app.wsgi_app)
    app.run()