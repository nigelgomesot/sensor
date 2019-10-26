# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


# Requirements

Entities:
message
timestamp
email
category
app_version
device_model
location

Sentiment:
positve/negative/neutral/mixed


Dashboard:
	Filters:
		datetime
		app version
		device model
		location
		sentiment(buttons)
	Sort:
		datetime
		sentiment score
	List:
		Email
		Message
		sentiment(label)

- Decide Tables
- Build Uploader(batch upload in sets of 25)
- Use Bootstrap
- Use Bigdata




# Tasks

[ ] Summary: Provide Slack's feedback channel analysis.

[ ] Scope:
	[ ] Data ingest: import slack data in offline mode
	[ ] Data process: derive below fields for each feedback
		[ ] Entities
		[ ] Keywords
		[ ] Sentiment
	[ ] Data analysis: provide a dashboard to analyze feedback

[ ] Impact:
	[ ] Identify issues based on Entities & Keywords
	[ ] Identify Sentiment of the product during each release

[ ] Plan:
	[ ] Data ingest:
		[ ] Script to ingest data from Slack
			- Store in DB on a daily basis
			- ref: https://api.slack.com/web
	[ ] Data process:
		[ ] perform Comprehend Batch* operations to fetch below details:
			[ ] Entities
			[ ] Keywords
			[ ] Sentiment
	[ ] Data analysis:
		[ ] Dahboard has below features:
			[ ] Filters:
				datetime
				app version
				device model
				location
				sentiment(buttons)
			[ ] Sort:
				datetime
				sentiment score
			[ ] List:
				Email
				Message
				sentiment(label)
[ ] Risk:
	False-positives: how do we ensure Sentiment analysis is correct?

