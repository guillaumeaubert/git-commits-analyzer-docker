#!/bin/bash

set -euf -o pipefail

# Define a horizontal line.
HLINE=$(printf '%*s\n' 80 '' | sed -e 's/ /─/g')
echo "$HLINE"

# Meta information.
OUTPUT_PATH="$OUTPUT_REPO/$GCA_OUTPUT_DIR"
echo "Looking for repos in /data."
echo "Output will be sent to $OUTPUT_PATH."

# Update the analyzer code.
echo "$HLINE"
echo "Updating ruby-git-commits-analyzer..."
cd $ANALYZER_REPO
git pull

# Update the output repo, in case anything has been committed to it since the
# last run.
echo "$HLINE"
echo "Updating output repository..."
cd $OUTPUT_REPO
git pull --rebase

# Analyze repos.
echo "$HLINE"
echo "Starting analysis at `date`."
ruby \
	-I $ANALYZER_REPO/lib \
	$ANALYZER_REPO/bin/analyze_commits \
	--author="$GCA_ANALYZE_AUTHOR" \
	--path="/data" \
	--output="$OUTPUT_PATH"
echo "Completed analysis at `date`."

# Commit updated statistics.
echo "$HLINE"
cd $OUTPUT_REPO
git push
git commit $GCA_OUTPUT_DIR/git_contributions* -m "Automated update of git stats."
git push
