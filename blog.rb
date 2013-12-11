#!/usr/local/rvm/rubies/ruby-2.0.0-p247/bin/ruby
require 'fileutils'
require 'optparse'
require 'redcarpet'
require 'yaml'
CONFIG = YAML::load_file(File.join(File.dirname(File.expand_path(__FILE__)), 'config.yml'))
current_time = Time.now

@pdir = CONFIG['posts_dir']
@output = CONFIG['output_dir']
@index = CONFIG['index_page']
@blog_title = CONFIG['blog_title']
@root = CONFIG['root_dir']
@template = "<center>Title: 

<br>Date: **#{current_time}**
</center>"
options = {}

puts @editor
puts ENV['EDITOR']
OptionParser.new do |opts|
  opts.banner = "Usage: blog.rb [options]"

  opts.on("-n", "New file") do |v|
    options[:verbose] = v
    @filename = ARGV.to_s
    @filename = @filename.gsub("[","").gsub("]","").gsub('"',"")
    FileUtils.touch("#{@pdir}/#{@filename}")
    File.open("#{@pdir}/#{@filename}", 'w') { |file| file.write(@template) }
  end

opts.on("-p", "Parse") do |v|
   options[:verbose] = v
    Dir.glob("#{@pdir}/*") do |post_file|
    text = File.read(post_file)
    markdown = Redcarpet.new(text)
    new = post_file.gsub("posts/","")
    File.open("#{@output}/#{new}.html", 'w') {|f| f.write(markdown.to_html) }  
   end
   Dir.glob("#{@output}/*") do |post_link|
    post_link = post_link.gsub("#{@root}","")
    if File.exist?(@index) == true
    File.open(@index, 'w') {|file| file.truncate(0) }
    File.open(@index, 'a') { |file| file.write("<center><h1>#{@blog_title}</h1></center>") }
    File.open(@index, 'a') { |file| file.write("<center><a href=\"#{post_link}\">#{post_link}</a></center>") }
    else
    FileUtils.touch(@index)
    File.open(@index, 'a') { |file| file.write("<center><a href=\"#{post_link}\">#{post_link}</a></center>") }
   end
   end
   end
  opts.on("-e", "Edit file") do |v|
    options[:verbose] = v
    @filename = ARGV.to_s
    @filename = @filename.gsub("[","").gsub("]","").gsub('"',"")
    system( "$VISUAL #{@pdir}/#{@filename}" )
  end
end.parse!
