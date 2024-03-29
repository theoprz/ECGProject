/*
|--------------------------------------------------------------------------
| Routes file
|--------------------------------------------------------------------------
|
| The routes file is used for defining the HTTP routes.
|
*/

import router from '@adonisjs/core/services/router'
const EcgsController = () => import('#controllers/ecgs_controller')
const TagsController = () => import('#controllers/tags_controller')

router.get('/', async () => {
  return {
    hello: 'world',
  }
})

router
  .group(() => {
    router.resource('/ecg', EcgsController).apiOnly()
    router.resource('/tag', TagsController).apiOnly()
  })
  .prefix('/api/v1')
