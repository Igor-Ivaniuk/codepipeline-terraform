# Imports
import logging
import os

import boto3

# Set up the logger
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Env variables from CFN
snstopic = os.environ.get('SNSTopic')
diff_absolute = os.environ.get('DiffAbsolute')
diff_percent = os.environ.get('DiffPercent')
pipeline_name = os.environ.get('PipelineName')
region = os.environ.get('Region')

# AWS clients
sns = boto3.client('sns')
pipeline_client = boto3.client('codepipeline')


def lambda_handler(event, context):
  logger.debug("#EVENT")
  logger.debug(event)

  record = event['Records'][0]
  message_id = record['messageId']
  message_attributes = record['messageAttributes']

  # Getting message attributes to local variables
  total = message_attributes['total-monthly-cost']['stringValue']
  past = message_attributes['past-total-monthly-cost']['stringValue']
  diff = message_attributes['diff-total-monthly-cost']['stringValue']

  # Diff body (text message)
  message_text = record['body']

  # Numeric values from strings
  f_diff_absolute = float(diff_percent)
  f_diff_percent = float(diff_percent)
  f_total = float(total)
  f_past = float(past)
  f_diff = float(diff)

  # If the absolute or relative difference is more than threshold
  if abs(f_diff) > f_diff_absolute:
    logger.info('Absolute threshold exceeded. Sending notification')
    subject = 'Pipeline {} needs approval - change absolute threshold {}$ exceeded'.format(pipeline_name, diff_absolute)
    send_approval_notification(message_text, subject)

  elif max(f_past, f_total, key=abs) > 0 and (abs(f_diff) * 100 / max(f_past, f_total, key=abs)) > f_diff_percent:
    logger.info('Percentage threshold exceeded. Sending notification')
    subject = 'Pipeline {} needs approval - change percentage threshold {}% exceeded'.format(pipeline_name,
                                                                                             diff_percent)
    send_approval_notification(message_text, subject)

  else:
    autoapprove(diff, past, total)


def send_approval_notification(message_text, subject):
  pipeline_url = 'https://console.aws.amazon.com/codesuite/codepipeline/pipelines/{}/view?region={}#/ReviewPlan/review-plan/approve/'.format(
    pipeline_name, region)
  message = f'''{subject}    
Pipeline: {pipeline_url}
Details:
{message_text}
'''
  logger.info('Sending email:')
  logger.info(message)
  sns_response = sns.publish(
    TopicArn=snstopic,
    Message=message,
    Subject=subject
  )
  logger.info(sns_response)


def autoapprove(diff, past, total):
  # Approving the pipeline
  logger.info('Auto-approving the changes')
  # Get the pipeline state token
  pipeline_state_response = pipeline_client.get_pipeline_state(name=pipeline_name)
  token = None
  exec_status = ''
  for state in pipeline_state_response['stageStates']:
    if state['stageName'] == 'ReviewPlan':
      exec_status = state['actionStates'][0]['latestExecution']['status']
      token = state['actionStates'][0]['latestExecution'].get('token')
  if exec_status == 'InProgress' and token is not None:
    logger.info('Approving the pipeline')
    msg = 'Current deployment costs changes: before {}$, after {}$, diff {}$. This is less than thresholds - {}$ or {}%. The pipeline is auto-approved'.format(
      past, total, diff, diff_absolute, diff_percent)
    logger.info(msg)
    approval_response = pipeline_client.put_approval_result(
      pipelineName=pipeline_name,
      stageName='ReviewPlan',
      actionName='review-plan',
      result={
        'summary': msg,
        'status': 'Approved'
      },
      token=token
    )
    logger.info(approval_response)
  else:
    logger.info('Cannot auto-approve, review-plan step is in {} status'.format(exec_status))
