from graphene.test import Client


client = Client(schema)

query = '''
    query TestQuery {
        workflow {
            name
        }
    }
    '''
client.execute(query)