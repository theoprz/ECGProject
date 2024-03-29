import type { HttpContext } from '@adonisjs/core/http'
import Tag from '#models/tag'

export default class TagsController {
  /**
   * Display a list of resource
   */
  async index({}: HttpContext) {
    return Tag.query()
  }

  /**
   * Handle form submission for the create action
   */
  async store({ request }: HttpContext) {
    return await Tag.create(request.body())
  }

  /**
   * Show individual record
   */
  async show({ params }: HttpContext) {
    return Tag.query().where('id', params.id).firstOrFail()
  }

  /**
   * Handle form submission for the edit action
   */
  async update({ params, request }: HttpContext) {
    const tag = await Tag.findOrFail(params.id)
    tag.merge(request.body())
    await tag.save()
    return tag
  }

  /**
   * Delete record
   */
  async destroy({ params }: HttpContext) {
    const tag = await Tag.findOrFail(params.id)
    await tag.delete()
    return tag
  }
}
