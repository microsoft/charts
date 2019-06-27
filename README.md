# Helm Hub
This repo houses helm charts for the Microsoft helm hub repository https://hub.helm.sh/charts/microsoft

Example usage:
```
helm repo add microsoft https://microsoft.github.io/charts/repo
helm install microsoft/spark --version 1.0.0
```

## Adding new charts

1. Automatically using circle-ci
Add your entry to your chart github repo in sources.yaml. Once merged into master, circle-ci will push your changes to the `gh-pages` branch for deployment.

2. Manually adding a chart
To contribute a chart, first create an archive of your chart using `helm package`. Then place the archive in the `repo` folder and update `repo/index.yaml`, `source.yaml` with your chart details. Create a branch with your work and merge it into the `gh-pages` branch to deploy. Turn off circle-ci and merge your work into master to prevent your work from being overwitten by autobuilds.



## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
