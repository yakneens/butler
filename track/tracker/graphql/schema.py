import graphene
from graphene import relay
from graphene_sqlalchemy import SQLAlchemyConnectionField, SQLAlchemyObjectType
import tracker
from dateutil import parser

from tracker.model.analysis import Analysis as AnalysisModel
from tracker.model.workflow import Workflow as WorkflowModel
from tracker.model.analysis_run import AnalysisRun as AnalysisRunModel
from tracker.model.configuration import Configuration as ConfigurationModel
import json

class Workflow(SQLAlchemyObjectType):

    class Meta:
        model = WorkflowModel
        interfaces = (relay.Node, )
       
        
class Analysis(SQLAlchemyObjectType):

    class Meta:
        model = AnalysisModel
        interfaces = (relay.Node, )
    



class AnalysisRun(SQLAlchemyObjectType):

    class Meta:
        model = AnalysisRunModel
        interfaces = (relay.Node, )
        
class Configuration(SQLAlchemyObjectType):

    class Meta:
        model = ConfigurationModel
        interfaces = (relay.Node, )

class ConfigInput(graphene.InputObjectType):
    config_id = graphene.ID(required=True)
    config = graphene.String(required=True)

class CreateConfiguration(relay.ClientIDMutation):
    class Input:
        my_config = ConfigInput()
        
    ok = graphene.Boolean()
    config = graphene.Field(Configuration)

    @classmethod
    def mutate_and_get_payload(cls, root, info, my_config, client_mutation_id=None):
        new_config = tracker.model.configuration.create_configuration(my_config.config_id, my_config.config)
        ok = True
        return CreateConfiguration(config=new_config, ok=ok)

class WorkflowInput(graphene.InputObjectType):
    workflow_name = graphene.String()
    workflow_version = graphene.String()
    config_id = graphene.ID(required=True)


class CreateWorkflow(relay.ClientIDMutation):
    class Input:
        my_workflow = WorkflowInput()
        
    ok = graphene.Boolean()
    workflow = graphene.Field(Workflow)
    
    @classmethod
    def mutate_and_get_payload(cls, root, info, my_workflow, client_mutation_id=None):
        new_workflow = tracker.model.workflow.create_workflow(my_workflow.workflow_name, my_workflow.workflow_version, my_workflow.config_id)
        ok = True
        return CreateWorkflow(workflow=new_workflow, ok=ok)

class AnalysisInput(graphene.InputObjectType):
    analysis_name = graphene.String()
    start_date = graphene.String()
    config_id = graphene.ID(required=True)

class CreateAnalysis(relay.ClientIDMutation):
    class Input:
        my_analysis = AnalysisInput()

        
    ok = graphene.Boolean()
    analysis = graphene.Field(Analysis)
    
    @classmethod
    def mutate_and_get_payload(cls, root, info, my_analysis, client_mutation_id=None):
        new_analysis = tracker.model.analysis.create_analysis(my_analysis.analysis_name, parser.parse(my_analysis.start_date), my_analysis.config_id)
        ok = True
        return CreateAnalysis(analysis=new_analysis, ok=ok)
    
class AnalysisRunInput(graphene.InputObjectType):
    workflow_id = graphene.Int(required=True)
    analysis_id = graphene.Int(required=True)
    config_id = graphene.ID(required=True)

class CreateAnalysisRun(relay.ClientIDMutation):
    class Input:
        my_analysis_run = AnalysisRunInput()

        
    ok = graphene.Boolean()
    analysis_run = graphene.Field(AnalysisRun)
    
    @classmethod
    def mutate_and_get_payload(cls, root, info, my_analysis_run, client_mutation_id=None):
        new_analysis_run = tracker.model.analysis_run.create_analysis_run(my_analysis_run.analysis_id, my_analysis_run.config_id, my_analysis_run.workflow_id)
        ok = True
        return CreateAnalysisRun(analysis_run=new_analysis_run, ok=ok)


class Query(graphene.ObjectType):
    node = relay.Node.Field()
    all_workflows = SQLAlchemyConnectionField(Workflow)
    all_analyses = SQLAlchemyConnectionField(Analysis)
    all_analysis_runs = SQLAlchemyConnectionField(AnalysisRun)
    
    workflow = graphene.Field(Workflow)
    analysis = graphene.Field(Analysis)
    analysis_run = graphene.Field(AnalysisRun)
    configuration = graphene.Field(Configuration)

class MyMutations(graphene.ObjectType):
    create_config  = CreateConfiguration.Field()
    create_workflow = CreateWorkflow.Field()
    create_analysis = CreateAnalysis.Field()
    create_analysis_run = CreateAnalysisRun.Field()


schema = graphene.Schema(query=Query, types=[Workflow, Analysis, AnalysisRun, Configuration], mutation=MyMutations)


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