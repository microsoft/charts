# this script parses the sources yaml files to fetch helm project sources

import os
from yaml import load, dump

charts = load(open("sources.yaml"))
repos = charts["repos"]

home = os.getcwd()

for repo in repos:
    print(repo)
    gh_repo = repo["github_repo"]
    name = repo["name"]
    branch =  repo["branch"]
    # os.system("cd /tmp/sources")
    os.system("rm -rf /tmp/sources/*")
    os.system("cd /tmp/sources && git clone --depth 1 -b {} https://github.com/{}.git {}".format(branch, gh_repo, name))
    for folder in repo["charts_path"]:
        os.system("cp -r /tmp/sources/{0}/{1} {2}".format(name,folder, os.path.join(home,"charts")) )
    

print(charts)