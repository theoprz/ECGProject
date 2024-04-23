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
const AuthController = () => import('#controllers/auth_controller')
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

    router.resource('/ecg', EcgsController).apiOnly()
    router.get('/ecg/:id/pdf', [EcgsController, 'uploadPdf'])
    router.get('/ecg/info/count', [EcgsController, 'count'])
    router.get('/ecg/info/:user', [EcgsController, 'indexByUser'])
    router.get('/ecg/info/image', [EcgsController, 'getImage'])
    router.post('/ecg/upload/file', [EcgsController, 'uploadFile'])
    router.get('/auth/callback', [AuthController, 'authCallback'])

    router.resource('/tag', TagsController).apiOnly()
  })
  .prefix('/api/v1')
