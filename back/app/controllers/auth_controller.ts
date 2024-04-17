// import type { HttpContext } from '@adonisjs/core/http'

import { HttpContext } from '@adonisjs/core/http'

export default class AuthController {
  async authCallback({ request, response }: HttpContext) {
    const code = request.input('code')
    const state = request.input('state')
    const redirectUri = 'com.group40.front://login-callback?code=' + code + '&state=' + state;

    return response.redirect(redirectUri)
  }
}
