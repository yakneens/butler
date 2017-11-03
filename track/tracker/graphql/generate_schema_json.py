import json
from schema import schema
import sys
from graphql.utils import schema_printer

#introspection_dict = schema.introspect()

# Print the schema in the console
#print json.dumps(introspection_dict)

# Or save the schema into some file
#fp = open("schema.json", "w")
#json.dump(introspection_dict, fp)
#fp.close()

my_schema_str = schema_printer.print_schema(schema)
fp = open("schema.graphql", "w")
fp.write(my_schema_str)
fp.close()