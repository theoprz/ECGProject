/*
|--------------------------------------------------------------------------
| Routes file
|--------------------------------------------------------------------------
|
| The routes file is used for defining the HTTP routes.
|
*/

import router from '@adonisjs/core/services/router'
import { HttpContext } from '@adonisjs/core/http'
const EcgsController = () => import('#controllers/ecgs_controller')
const TagsController = () => import('#controllers/tags_controller')

router.get('/', async () => {
  return {
    hello: 'world',
  }
})

router
  .group(() => {
    router.get('/', async ({ response }: HttpContext) => {
      return response.status(200).json({ description: 'Welcome to the ECG API', content: null })
    })
    router.get('/ecg/count', [EcgsController, 'count'])
    router.resource('/ecg', EcgsController).apiOnly()
    router.resource('/tag', TagsController).apiOnly()
  })
  .prefix('/api/v1')
