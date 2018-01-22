1. Steps to setup the blog api application

- git clone https://github.com/harshitharao/blog-api.git
- cd blog-api
- bundle install
- rake db:create db:migrate

2. I am using token based authentication for the apis. Initially I would create few users manually from the
rails console. Follow the steps to create a user and use the blog apis

- rails c
- User.create!(name: 'Sample user 1', email: 'example@mail.com', password: '123123123')
- curl -H "Content-Type: application/json" -X POST -d '{"email":"example@mail.com","password":"123123123"}' http://localhost:3000/authenticate
    would return {"auth_token": <token>}
- <token> should be passed in the headers to access apis
Ex: curl -H "Authorization: <token>" http://localhost:3000/blogs

3. How to run the test suite

- RAILS_ENV=test rake db:create db:migrate
- rspec

4. Api endpoints supported

- GET http://localhost:3000/blogs #Fetch all the blogs
- GET http://localhost:3000/blogs/:id #Fetch a specific blog which contains the full content(Ex: http://localhost:3000/blogs/1)
- PUT http://localhost:3000/blogs/:id?is_favorite=true #Update blog as favorite or not(Ex: http://localhost:3000/blogs/1?is_favorite=true or http://localhost:3000/blogs/1?is_favorite=false)

5. Token based Authentication for apis

- curl -H "Authorization: <token>" http://localhost:3000/blogs #Returns the blogs along with is_favorite attribute
- http://localhost:3000/blogs #Returns the blogs without is_favorite attribute
- curl -H "Authorization: <token>" http://localhost:3000/blog/1 #Returns blog 1 along with is_favorite attribute
- http://localhost:3000/blog/1 #Returns blog 1 along without is_favorite attribute
- There is no option to mark or unmark the blog as favorite if the user is not logged in or user is not authenticated
- curl -H "Authorization: <token>" http://localhost:3000/blogs/1?is_favorite=true #Returns successfully updated msg
- http://localhost:3000/blogs/1?is_favorite=true #Returns unauthorized

6. Services

Cronjob is created to run a rake task every midnight
- rake development:fetch_blogs_from_rss_feed or RAILS_ENV=development bundle exec rake development:fetch_blogs_from_rss_feed  #To run the rake task manually
