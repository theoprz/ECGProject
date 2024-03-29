import type { HttpContext } from '@adonisjs/core/http'
import Ecg from '#models/ecg'

export default class EcgsController {
  /**
   * Display a list of resource
   */
  async index({}: HttpContext) {
    return Ecg.query().preload('tags')
  }

  /**
   * Handle form submission for the create action
   */
  async store({ request }: HttpContext) {
    return Ecg.create(request.body())
  }

  /**
   * Show individual record
   */
  async show({ params }: HttpContext) {
    return Ecg.query().where('id', params.id).firstOrFail()
  }

  /**
   * Handle form submission for the edit action
   */
  async update({ params, request }: HttpContext) {
    const ecg = await Ecg.findOrFail(params.id)
    ecg.merge(request.body())
    await ecg.save()
    return ecg
  }

  /**
   * Delete record
   */
  async destroy({ params }: HttpContext) {
    const ecg = await Ecg.findOrFail(params.id)
    await ecg.delete()
    return ecg
  }
}
