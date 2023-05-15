#!/bin/bash
#
# Based on the argument:
# 1. By default, serve the SLSA website on your local machine.
# 2. Prepare bundle, ruby, and the SLSA webiste dir before building or serving.

serve_website="true"
while getopts 'sh' flag; do
  case "${flag}" in
    s) 
      serve_website=${OPTARG}
      ;;
    h) 
      echo "Usage: use -s flag to indicate if you want to launch the build, default is false"
      exit
      ;;
    *)
      echo "Error: only -s and -h are supported"
      exit
  esac
done

if [[ -d "slsa-test" ]]; then
  rm -rf slsa-test
fi

sudo apt install ruby ruby-dev bundler
git clone --recurse-submodules https://github.com/chtiangg/slsa.git slsa-test
cd slsa-test/docs
git switch test/main
git submodule update --remote
bundle config set --local path 'vendor/bundle'
bundle install

if [[ -z "${serve_website}" ]]; then
  echo "Empty build flag means not building the website. Exit."
elif [[ "${serve_website}" == "true" ]]; then
  echo "\nStart to serve the website."
  bundle exec jekyll serve --livereload --incremental
else
  echo "\nFinsh retrieving code and install bundle. Exit."
fi
