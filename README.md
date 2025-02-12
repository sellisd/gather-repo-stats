# gather-repo-stats

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/sellisd/gather-repo-stats)

Workflow to gather descriptive statistics from github repositories

## Usage

```shell
docker build -t gather .
docker run -v ~/.ssh:/root/.ssh:ro -v ${PWD}/dockerresults/:/results -v ${PWD}//data:/data gather
```