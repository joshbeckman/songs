require 'podcast_feed_gen'

gen = PodcastFeedGen::Generator.new

rss = gen.gen!

print rss
