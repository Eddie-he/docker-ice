#!/bin/bash

setup_git() {
  echo "Setting up git config..."
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

update_ice_version() {
  echo "Updating Dockerfile and commiting to master..."
  sed -i "/ENV\ ICE_VERSION/c\ENV\ ICE_VERSION\ $NEW_VERSION" ice/Dockerfile
  git commit ice/Dockerfile -m "Created new release: $NEW_VERSION"
  git push
}

create_release_tag() {
  echo "Creating release tag..."
  sed -i "/ENV\ ICE_VERSION/c\ENV\ ICE_VERSION\ $NEW_VERSION" ice/Dockerfile
  git tag -m "New version of ICE" "$NEW_VERSION.0"
  git remote rm origin
  git remote add origin https://$GH_TOKEN@github.com/jonbrouse/docker-ice.git > /dev/null 2>&1
  git push --quiet --set-upstream origin
  git push --tags
}

setup_git
update_ice_version
create_release_tag
