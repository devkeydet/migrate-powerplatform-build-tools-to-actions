# migrate-powerplatform-build-tools-to-actions

This sample demonstrates how to use [GitHub Actions Importer](https://docs.github.com/en/actions/migrating-to-github-actions/automated-migrations/automating-migration-with-github-actions-importer) to convert an Azure DevOps Pipeline that uses tasks from the [Microsoft Power Platform Build Tools for Azure DevOps](https://learn.microsoft.com/en-us/power-platform/alm/devops-build-tools) to a GitHub Workflow that uses actions from the [GitHub Actions for Microsoft Power Platform](https://learn.microsoft.com/en-us/power-platform/alm/devops-github-actions). Since [GitHub Actions Importer](https://docs.github.com/en/actions/migrating-to-github-actions/automated-migrations/automating-migration-with-github-actions-importer) does not natively migrate [Microsoft Power Platform Build Tools for Azure DevOps](https://learn.microsoft.com/en-us/power-platform/alm/devops-build-tools) to [GitHub Actions for Microsoft Power Platform](https://learn.microsoft.com/en-us/power-platform/alm/devops-github-actions), the sample uses a [custom transformer](https://docs.github.com/en/actions/migrating-to-github-actions/automated-migrations/extending-github-actions-importer-with-custom-transformers) to supplement and enable a successful migration.

After following the instructions at [Migrating from Azure DevOps with GitHub Actions Importer](https://docs.github.com/en/actions/migrating-to-github-actions/automated-migrations/migrating-from-azure-devops-with-github-actions-importer), you should be able to use the `power-platform.rb` file with the `--custom-transformers` paramater similar to:

`gh actions-importer audit azure-devops --output-dir audit --custom-transformers power-platform.rb`

This custom transformer only accounts for two task to action conversions.  The sample source Azure DevOps pipeline used was:

```yaml
trigger: none
pool:
  vmImage: ubuntu-latest
steps:
- task: PowerPlatformToolInstaller@2
  displayName: Install Power Platform Build Tools
  inputs:
    DefaultVersion: true
- task: PowerPlatformWhoAmi@2
  displayName: Call WhoAmI
  inputs:
    authenticationType: PowerPlatformSPN
    PowerPlatformSPN: pipelines-spn
    Environment: "$(BuildTools.EnvironmentUrl)"
```

The converted GitHub Workflow produced:

```yaml
name: ado-proj-name/ado-pipeline-name
on:
  workflow_dispatch:
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: checkout
      uses: actions/checkout@v4.1.0
    - name: Install Power Platform Build Tools
      uses: microsoft/powerplatform-actions/actions-install@v1
    - name: Call WhoAmI
      uses: microsoft/powerplatform-actions/who-am-i@v1
      with:
        environment-url: "${{secrets.ENVIRONMENT_URL}}"
        tenant-id: "${{secrets.PIPELINES_SPN_TENANT_ID}}"
        app-id: "${{secrets.PIPELINES_SPN_APP_ID}}"
        client-secret: "${{secrets.PIPELINES_SPN_CLIENT_SECRET}}"
```
