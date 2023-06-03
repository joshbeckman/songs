#!/usr/bin/env ruby

require 'ostruct'
require 'nokogiri'

feed = File.open("_site/podcast/index.rss") { |f| Nokogiri::XML(f) }
title = feed.xpath('//channel/title').first.text
description = feed.xpath('//channel/description').first.text
copyright = feed.xpath('//channel/copyright').first.text
link = feed.xpath('//channel/link').first.text
image_url = feed.xpath('//channel/itunes:image').first.attr('href')
items = feed.xpath('//channel/item').map do |item|
  OpenStruct.new(
    title: item.xpath('title').first.text,
    description: item.xpath('description').first.text,
    link: item.xpath('link').first.text,
    image_url: item.xpath('itunes:image').first.attr('href')
  )
end
items_html = items.map do |item|
  <<-html
  <div class="item">
    <img src="#{item.image_url}" alt="#{item.title}"/>
    <h2>#{item.title}</h2>
    <p>#{item.description}</p>
    <audio src="#{item.link}" controls/>
  </div>
  <hr/>
  html
end.join

header = <<-html
<head>
  <title>#{title}</title>
  <meta property="og:description" content="#{description}"/>
  <meta property="og:image" content="#{image_url}">
  <link href="./style.css" rel="stylesheet" />
</head>
html

links = <<-html
<a href="//www.joshbeckman.org">#{copyright}</a>
-
<a href="https://podcasts.apple.com/us/podcast/josh-songs/id1689956820">iTunes</a>
-
<a href="#{link}">Podcast/RSS</a>
-
<a href="https://github.com/joshbeckman/songs">Source</a>
html

body = <<-html
<img src="#{image_url}" alt="#{title}"/>
<h1>#{title}</h1>
<p>#{description}</p>
<p>#{links}</p>
<hr/>
#{items_html}
html

puts <<-html
<html>
  #{header}
  <body>#{body}</body>
</html>
html
