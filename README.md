# gather-repo-stats

Workflow to gather descriptive statistics from github repositories

## Usage

```shell
docker build -t gather .
docker run -v ~/.ssh:/root/.ssh:ro -v ${PWD}/dockerresults/:/results -v ${PWD}/data:/data gather download # download data
docker run -v ~/.ssh:/root/.ssh:ro -v ${PWD}/dockerresults/:/results -v ${PWD}/data:/data gather analyze # run analysis
```