blog.rb
=======

blog.rb - a simple and minimal static blog generator

setup
=======
1. open up config.yml 

2. and change the first line to where you keep the markup posts

3. change output_dir to your /var/www/blog/posts/ directory(this is where the html files will go to)

4. change index_html to where you have the main blog page(usually /var/www/blog/index.html)

5. change blog_title to your desired title.

6. set root_dir

first_post
=======
```shell
$ ./blog.rb -n post_name (this will create a template in the posts/ directory)
$ ./blog.rb -e post_name (this will open up the post in your favorite editor.($EDITOR))
$ ./blog -p will parse all of the posts and move them to the output directory.
```

