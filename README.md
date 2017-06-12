Docker Image for ruby-git-commits-analyzer
==========================================


Code Status
-----------

[![Docker Pulls](https://img.shields.io/docker/pulls/aubertg/ruby-git-commits-analyzer-docker.svg)](https://hub.docker.com/r/aubertg/ruby-git-commits-analyzer-docker/)


Overview
--------

A Docker image that runs ruby-git-commits-analyzer on a regular basis and pushes updated git contribution statistics to a separate repo.

	docker pull aubertg/ruby-git-commits-analyzer-docker
	docker run \
		-v /my/host/git/repos/directory/:/data \
		-v /my/host/ssh/deploy/dir:/home/gca/.ssh \
		-t \
		-d \
		--name=GitContributionsAnalyzer \
		-e GCA_ANALYZE_AUTHOR="test@example.com" \
		-e GCA_COMMIT_NAME="Git Analyzer" \
		-e GCA_COMMIT_EMAIL="test+gitcontributions@example.com" \
		-e GCA_OUTPUT_REPO="git@github.com:...git" \
		-e GCA_OUTPUT_DIR="data/" \
		-e GCA_ANALYZE_ON_STARTUP="yes" \
		aubertg/ruby-git-commits-analyzer-docker


Volumes
-------

The container supports the following volumes:

* **`/data`** *(required)*  
  A directory where all the git repositories to analyze are stored.

* **`/home/gca/.ssh`** *(optional)*  
	A directory that holds the ssh configuration required to push commits to the
	output repository.


Environment Variables
---------------------

The container is configurable through the following environment variables:

* **`GCA_TIMEZONE`** *(optional)*  
  Timezone for the processes; defaults to `America/Los_Angeles`.

* **`GCA_ANALYZE_AUTHOR`** *(required)*  
	The commit email address of the author whose contributions you are analyzing.

* **`GCA_COMMIT_NAME`** *(required)*  
	The name to use to commit updates to the output repository.

* **`GCA_COMMIT_EMAIL`** *(required)*  
	The email to use to commit updates to the output repository.

* **`GCA_OUTPUT_REPO`** *(required)*  
	URL of the git repository to which updated contribution statistics should be
	pushed.

* **`GCA_OUTPUT_DIR`** *(required)*  
	Inside of `GCA_OUTPUT_REPO`, the relative path of the directory in which
	contribution statistics should be stored.

* **`GCA_ANALYZE_ON_STARTUP`** *(optional)*  
	Set this to `yes` to trigger an analysis on container startup; defaults to `no`.


Copyright
---------

Copyright (C) 2017 Guillaume Aubert.


License
-------

This software is released under the MIT license. See the LICENSE file for
details.


Disclaimer
----------

I am providing code in this repository to you under an open source license.
Because this is my personal repository, the license you receive to my code is
from me and not from my employer (Facebook).
