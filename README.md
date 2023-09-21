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
|:---|:---|:---:|
| A | b | c |
|  |  |  |
|  |  |  |
|  |  |  |