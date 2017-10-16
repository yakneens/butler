from graphene.test import Client
from schema import schema
from examples.complex_example import query

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

variable_values = '''
    {
        "workflow": {
            "workflowName":"QWERA",
            "workflowVersion":"asdasd",
            "configId":"e08df590-1b28-440d-84ab-be14266ada93"
        },
        "config": {
            "configId":"e08df590-1b28-440d-84ab-be14266ada93",
            "config": "{\"blah\": \"blah\"}"
        },
        "analysis": {
            "analysisName": "My analysis",
            "startDate": "10-15-2017",
            "configId": "e08df590-1b28-440d-84ab-be14266ada93"
        },
        "analysisRun": {
            "workflowId": 1,
            "analysisId": 1,
            "configId": "e08df590-1b28-440d-84ab-be14266ada93"
        }
    }
    '''
for my_query in query_list:
    client.execute(my_query, variable_values=variable_values)