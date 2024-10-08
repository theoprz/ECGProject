import type { HttpContext } from '@adonisjs/core/http'
import Tag from '#models/tag'

export default class TagsController {
  /**
   * Display a list of resource
   */
  async index({ response }: HttpContext) {
    const tags = await Tag.query()

    if (tags) {
      return response.status(200).json({ description: 'Tags found', content: tags })
    } else {
      return response.status(404).json({ description: 'No tags found', content: null })
    }
  }

  /**
   * Handle form submission for the create action
   */
  async store({ request, response }: HttpContext) {
    if (request.input('name') && request.input('main') && request.input('weight')) {
      const tag = await Tag.create(request.body())

      if (tag) {
        return response.status(201).json({ description: 'Tag created', content: tag })
      } else {
        return response.status(500).json({ description: 'Tag not created', content: null })
      }
    } else {
      return response.status(406).json({ description: 'Missing required fields', content: null })
    }
  }

  /**
   * Show individual record
   */
  async show({ params, response }: HttpContext) {
    const tag = await Tag.query().where('id', params.id).first()

    if (tag) {
      return response.status(200).json({ description: 'Tag found', content: tag })
    } else {
      return response.status(404).json({ description: 'Tag not found', content: null })
    }
  }

  /**
   * Handle form submission for the edit action
   */
  async update({ params, request, response }: HttpContext) {
    const tag = await Tag.find(params.id)
    if (tag) {
      tag.merge(request.body())
      await tag.save()

      if (tag) {
        return response.status(200).json({ description: 'Tag updated', content: tag })
      } else {
        return response.status(500).json({ description: 'Tag not updated', content: null })
      }
    } else {
      return response.status(404).json({ description: 'Tag not found', content: null })
    }
  }

  /**
   * Delete record
   */
  async destroy({ params, response }: HttpContext) {
    const tag = await Tag.find(params.id)

    if (tag) {
      await tag.delete()
      return response.status(200).json({ description: 'Tag deleted', content: null })
    } else {
      return response.status(404).json({ description: 'Tag not found', content: null })
    }
  }
}
