# All HTTP routes are defined in this file.
# 

module.exports =
  statements:
    put: 'statements#update'
    post: 'statements#create'
    get: 'statements#index'
  'statements/:id':
    get: 'statements#show'

  request_token:
    get: 'oauth#request_token'

  access_token:
    get: 'oauth#access_token'

  authorize:
    get: 'oauth#authorize_token'
