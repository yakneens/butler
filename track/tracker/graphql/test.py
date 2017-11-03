from graphene.test import Client
from schema import schema
from examples.complex_example import query
from uuid import uuid4
client = Client(schema)

add_workflow_query = '''
    mutation addWorkflow($workflow: WorkflowInput){
      createWorkflow(input:{myWorkflow:$workflow}){
        workflow {
          workflowName
          workflowId
          workflowVersion
          configId
        }
      }
    }
    '''
    
add_config_query = '''
    mutation addConfig($config: ConfigInput){
      createConfig(input:{myConfig: $config}){
        config {
          configId
          config
        }
        ok
      }
    }
    '''

add_analysis_query = '''
    mutation addAnalysis($analysis: AnalysisInput){
      createAnalysis(input:{myAnalysis: $analysis}){
        analysis{
          analysisId
          analysisName
          startDate
          configId
        }
        ok
      }
    }
    '''
    
add_analysis_run_query = '''
    mutation addAnalysisRun($analysisRun: AnalysisRunInput){
      createAnalysisRun(input: {myAnalysisRun: $analysisRun}){
        analysisRun{
          analysisId
          workflowId
          analysisRunId
          configId
        }
      }
    }
    '''
query_list = [add_config_query, add_workflow_query, add_analysis_query, add_analysis_run_query]

config_id = str(uuid4())

variable_values = '''
    {
        "workflow": {
            "workflowName":"QWERA",
            "workflowVersion":"asdasd",
            "configId":"''' + config_id + '''"
        },
        "config": {
            "configId":"''' + config_id + '''",
            "config": "{\"blah\": \"blah\"}"
        },
        "analysis": {
            "analysisName": "My analysis",
            "startDate": "10-15-2017",
            "configId": "''' + config_id + '''"
        },
        "analysisRun": {
            "workflowId": 1,
            "analysisId": 1,
            "configId": "''' + config_id + '''"
        }
    }
    '''
for my_query in query_list:
    client.execute(my_query, variable_values=variable_values)