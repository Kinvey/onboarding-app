angular.module 'app.state', ['ui.router']
  .config ['$stateProvider', '$injector',
           ($stateProvider, $injector) ->

             angular.forEach [
               'app.state.login'
               'app.state.logged-in'
             ], (stateName) ->

               state = $injector.get(stateName)
               $stateProvider.state(state.name, state)
   ]