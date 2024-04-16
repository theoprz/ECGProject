// import type { HttpContext } from '@adonisjs/core/http'

import { HttpContext } from '@adonisjs/core/http'

export default class AuthController {
  async authCallback({ request, response }: HttpContext) {
    console.log(request.url())

    return response.status(200).json({ description: 'Auth callback', content: null })
  }
}
