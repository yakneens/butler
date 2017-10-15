import graphene
from graphene import relay
from graphene_sqlalchemy import SQLAlchemyConnectionField, SQLAlchemyObjectType
import tracker.model.workflow

from tracker.model.analysis import Analysis
from tracker.model.workflow import Workflow
from tracker.model.analysis_run import AnalysisRun
from tracker.model.configuration import Configuration
import json

class WorkflowQ(SQLAlchemyObjectType):

    class Meta:
        model = Workflow
        interfaces = (relay.Node, )


class createWorkflow(graphene.Mutation):
    class Arguments:
        workflowName = graphene.String()
        workflowVersion = graphene.String()
        configId = graphene.String()
        
    ok = graphene.Boolean()
    workflow = graphene.Field(WorkflowQ)

    @classmethod
    def mutate(cls, _, args, context, info):
        workflow = create_workflow(args.get("workflowName"), args.get("workflowVersion"), args.get("configId"))
        ok = True
        return createWorkflow(workflow=workflow, ok=ok)


class AnalysisQ(SQLAlchemyObjectType):

    class Meta:
        model = Analysis
        interfaces = (relay.Node, )


class AnalysisRunQ(SQLAlchemyObjectType):

    class Meta:
        model = AnalysisRun
        interfaces = (relay.Node, )
        
class ConfigurationQ(SQLAlchemyObjectType):

    class Meta:
        model = Configuration
        interfaces = (relay.Node, )


class Query(graphene.ObjectType):
    node = relay.Node.Field()
    all_workflows = SQLAlchemyConnectionField(WorkflowQ)
    all_analyses = SQLAlchemyConnectionField(AnalysisQ)
    all_analysis_runs = SQLAlchemyConnectionField(AnalysisRunQ)
    
    workflow = graphene.Field(WorkflowQ)
    analysis = graphene.Field(AnalysisQ)
    analysis_run = graphene.Field(AnalysisRunQ)
    configuration = graphene.Field(ConfigurationQ)

class MyMutations(graphene.ObjectType):
    create_workflow = createWorkflow.Field()


schema = graphene.Schema(query=Query, types=[WorkflowQ, AnalysisQ, AnalysisRunQ, ConfigurationQ], mutation=MyMutations)


from graphene.test import Client


client = Client(schema)

query = '''
    query TestQuery {
       analysis {
           analysisName
       }
    }
    '''
    
query3 = '''
    {
        allWorkflows {
            edges {
                node {
                    workflowId
                }
            }
        }
    }
    '''
    
query2 = '''
    {
        __schema {
            types {
                name
                fields {
                    name
                    type {
                        name
                        kind
                    }
                }
            }
        }
    }
    '''
#print(json.dumps(client.execute(query3), indent=4))