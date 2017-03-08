#!/bin/bash
# Install the kendo pro registry token to the heroku vm

echo @progress:registry=https://registry.npm.telerik.com/ > .npmrc
echo //registry.npm.telerik.com/:_authToken=\"LcYJZJAYWdxWQeGTAr/Ba9vyBlVEqR4SPOzSiju6YqlcxAPQJiDbseqQGxkKfoYi\" >> .npmrc
