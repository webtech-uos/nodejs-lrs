# All API HTTP routes are defined in this file.
# 

module.exports =
  'statements':
    put: 'statements#update'
    post: 'statements#create'
    get: 'statements#index'
  'statements/:id':
    get: 'statements#show'
  'about':
    get: 'about#info'
