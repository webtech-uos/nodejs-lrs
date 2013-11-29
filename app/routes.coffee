module.exports = 
  statements:
    put: 'statements#update'
    post: 'statements#create'
    get: 'statements#index'
  'statements/:id':
    get: 'statements#show'
