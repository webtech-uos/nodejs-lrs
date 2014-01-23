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
  'activities/state':
    get: 'activities_state#index'
    put: 'activities_state#update'
    post: 'activities_state#create'
    'delete': 'activities_state#delete'
  'activities/profile':
    get: 'activities_profile#index'
    put: 'activities_profile#update'
    post: 'activities_profile#create'
    'delete': 'activities_profile#delete' 
  'agent/profile':
    get: 'agent_profile#index'
    put: 'agent_profile#update'
    post: 'agent_profile#create'
    'delete': 'agent_profile#delete' 
