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
@template = "<center>
Title Here
============= 

Date: **#{current_time}**
</center>"
options = {}

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
    @new = post_file.gsub("posts/","")
    File.open("#{@output}/#{@new}.html", 'w') {|f| f.write(markdown.to_html) }  
    File.open("#{@output}/#{@new}.html", 'a') { |f| f.write("<center><a href=\"../\">home</a></center>") } 
   end
   end

   FileUtils.rm("#{@index}")
   File.open(@index, 'w+') { |file| file.write("<center><h1>#{@blog_title}</h1></center>") }
   Dir.glob("#{@output}/*") do |post_link|
    post_link = post_link.gsub("#{@root}","")
    File.open(@index, 'a+') { |file| file.write("
<center><a href=\"#{post_link}\">#{post_link}</a></center>") }
   end
  opts.on("-e", "Edit file") do |v|
    options[:verbose] = v
    @filename = ARGV.to_s
    @filename = @filename.gsub("[","").gsub("]","").gsub('"',"")
    system( "$VISUAL #{@pdir}/#{@filename}" )
  end
end.parse!


