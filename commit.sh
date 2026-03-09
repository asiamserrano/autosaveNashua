#!/bin/bash

# add all swift files
git add \*.swift
git add PreviewStores/*
git add Resources/*
git add \*.txt
git add \*.pages

# add specific non-swift files 
git add .gitignore
git add commit.sh

#git add autosaveBeta.xcodeproj/*
git add autosaveNashua/Assets.xcassets/*
git add README.md


# commit, push, status
git commit -m "${1:-updates}"  
git push
git status
