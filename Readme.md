![Vision](https://i.ytimg.com/vi/0Z0BEOnGREQ/maxresdefault.jpg)

# INSTALL
Firstly, fork this repo and set it up locally:
```
$ git clone <your_git_repo_url> <folder>
$ cd <folder>
```
If you don't already have bundler gem:
```
$ gem install bundler
```
Install dependencies:
```
$ bundle install
```

# HOW To USE
Make sure you are in app folder. To run scraper:
```
$ ruby web_scraper.rb
```
To inspect HTML through Pry, un-hash line 152 in web_scraper.rb:
```
web_scraper.rb

152 # Pry.start(binding)
```

# Contributing
Please submit pull requests. Make sure your local repo is up-to-date before making changes!
