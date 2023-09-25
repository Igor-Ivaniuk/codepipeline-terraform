# Terraform build pipeline with AWS CodePipelines and costs estimation

Terraform is an infrastructure-as-code (IaC) tool that helps you create, update, and version your infrastructure in a secure and repeatable manner.

The scope of this pattern is to provide an example terraform configurations to setup pipeline with costs validation based on AWS CodePipeline, AWS CodeBuild, Terraform and Infracost.

The created pipeline uses the common practices for infrastructure lifecycle and has the below stages

- plan - This stage creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.
- check costs - This stage prepares the costs report that can help to estimate the changes in monthly costs for the infrastructure managed by current Terraform project
- review plan - This stage represents a manual approval step needed to decide if the given plan
- apply - This stage uses the plan created above to provision the infrastructure in the test account.

## CloudFormation template variables

| **Name** | **Description** | **Default value** |
|---|---|---|
| BuildImageName | Build container for the pipeline step | aws/codebuild/amazonlinux2-x86_64-standard:3.0 |
| PipelineBucket | S3 bucket to use with CodePipelines and store pipeline artifacts |  |
| InitialSubscriberEmail | EMail address that will receive manual approval requests | NONE |
| GitHubRepo | GitHub repository to monitor, as <Organization name>/<repository> |  |
| GitHubBranch | Branch that will be monitored | main |
| CodeStarConnectionArn | ARN of the CodeStar - GitHub connection -Infracost [see below](#codestar-connection) |  |
| Environment | Environment name | dev |
| InfracostApiKey | API key for Infracost utility - [see below](#infracost-api-key) |  |

## CodeStar connection
AWS CodeStar Connections is a feature that allows services like AWS CodePipeline to access third-party code source provider. For our example, you can now seamlessly connect your GitHub source repository to AWS CodePipeline. This allows you to automate  the build, test, and deploy phases of your release process each time a code change occurs.
When a push is made to a monitored GitHub repo, the CodePipeline will trigger.

Please use the [instructions in the AWS blog post](https://aws.amazon.com/blogs/devops/using-aws-codepipeline-and-aws-codestar-connections-to-deploy-from-bitbucket/) to set up a Connection for GitHub. When done, provide the AN of the connection into **CodeStarConnectionArn** param.

## Infracost API Key
[**Infracost**](https://github.com/infracost/infracost) is a tool to show cloud cost estimates for Terraform. Infracost supports over **1,000** Terraform resources across [AWS](https://www.infracost.io/docs/supported_resources/aws), [Azure](https://www.infracost.io/docs/supported_resources/azure) and [Google](https://www.infracost.io/docs/supported_resources/google). We will be using it to create a costs breakdown in our sample Terraform project

To use the open source Infracost utility, please create a free account at (infracost.io) - you can sign up with your GitHub account. Then [get an API key](https://www.infracost.io/docs/#2-get-api-key) and provide it into the **InfracostApiKey** param
