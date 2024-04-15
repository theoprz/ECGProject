import type { HttpContext } from '@adonisjs/core/http'
import Ecg from '#models/ecg'

export default class EcgsController {
  /**
   * Display a list of resource
   */
  async index({ response }: HttpContext) {
    const ecgs = await Ecg.query().preload('tags')

    if (ecgs) {
      return response.status(200).json({ description: 'Ecg records found', content: ecgs })
    } else {
      return response.status(404).json({ description: 'No Ecg found', content: null })
    }
  }

  /**
   * Handle form submission for the create action
   */
  async store({ request, response }: HttpContext) {
    const ecg = await Ecg.create(request.body())
    if (request.input('tags') !== undefined) {
      await ecg.related('tags').attach(request.input('tags'))
    }

    if (ecg) {
      const ecgToReturn = await Ecg.query().preload('tags').where('id', ecg.id).firstOrFail()
      return response.status(201).json({ description: 'Ecg record created', content: ecgToReturn })
    } else {
      return response.status(400).json({ description: 'Ecg record not created', content: null })
    }
  }

  /**
   * Show individual record
   */
  async show({ params, response }: HttpContext) {
    const ecg = await Ecg.query().preload('tags').where('id', params.id).firstOrFail()

    if (ecg) {
      return response.status(200).json({ description: 'Ecg record found', content: ecg })
    } else {
      return response.status(404).json({ description: 'Ecg record not found', content: null })
    }
  }

  /**
   * Handle form submission for the edit action
   */
  async update({ params, request, response }: HttpContext) {
    const ecg = await Ecg.findOrFail(params.id)
    ecg.merge(request.body())
    await ecg.save()
    if (request.input('tags') !== undefined) {
      await ecg.related('tags').sync(request.input('tags'))
    }

    if (ecg) {
      const ecgToReturn = await Ecg.query().preload('tags').where('id', ecg.id).firstOrFail()
      return response.status(200).json({ description: 'Ecg record updated', content: ecgToReturn })
    } else {
      return response.status(400).json({ description: 'Ecg record not updated', content: null })
    }
  }

  /**
   * Delete record
   */
  async destroy({ params, response }: HttpContext) {
    const ecg = await Ecg.findOrFail(params.id)

    if (ecg !== null) {
      await ecg.delete()
      return response.status(200).json({ description: 'Ecg record deleted', content: null })
    } else {
      return response.status(404).json({ description: 'Ecg record not found', content: null })
    }
  }

  /**
   * Display how many records are in the database
   */
  async count({}: HttpContext) {
    const ecgs = await Ecg.query()
    return ecgs.length
  }
}
