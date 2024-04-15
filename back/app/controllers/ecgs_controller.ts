import type { HttpContext } from '@adonisjs/core/http'
import Ecg from '#models/ecg'
import { v4 as uuidv4 } from 'uuid'
import * as fs from 'node:fs'

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
    if (
      request.input('filename') &&
      request.input('title') &&
      request.input('contexte') &&
      request.input('comment') &&
      request.input('age') &&
      request.input('sexe') &&
      request.input('posted_by') &&
      request.input('validated_by') &&
      request.input('created') &&
      request.input('validated') &&
      request.input('pixels_cm') &&
      request.input('speed') &&
      request.input('gain') &&
      request.input('quality')
    ) {
      const ecg = await Ecg.create(request.body())
      if (request.input('tags') !== undefined) {
        await ecg.related('tags').attach(request.input('tags'))
      }
      if (ecg) {
        const ecgToReturn = await Ecg.query().preload('tags').where('id', ecg.id).firstOrFail()
        return response
          .status(201)
          .json({ description: 'Ecg record created', content: ecgToReturn })
      } else {
        return response.status(400).json({ description: 'Ecg record not created', content: null })
      }
    } else {
      return response.status(400).json({ description: 'Missing required fields', content: null })
    }
  }

  /**
   * Show individual record
   */
  async show({ params, response }: HttpContext) {
    const ecg = await Ecg.query().preload('tags').where('id', params.id).first()

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
    const ecg = await Ecg.find(params.id)
    if (ecg) {
      ecg.merge(request.body())
      await ecg.save()
      if (request.input('tags') !== undefined) {
        await ecg.related('tags').sync(request.input('tags'))
      }

      if (ecg) {
        const ecgToReturn = await Ecg.query().preload('tags').where('id', ecg.id).firstOrFail()
        return response
          .status(200)
          .json({ description: 'Ecg record updated', content: ecgToReturn })
      } else {
        return response.status(400).json({ description: 'Ecg record not updated', content: null })
      }
    } else {
      return response.status(404).json({ description: 'Ecg record not found', content: null })
    }
  }

  /**
   * Delete record
   */
  async destroy({ params, response }: HttpContext) {
    const ecg = await Ecg.find(params.id)

    if (ecg) {
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

  async uploadFile({ request, response }: HttpContext) {
    const imageFile = request.file('image')

    if (!imageFile) {
      return response.status(400).send('No file uploaded')
    }

    const uuid = uuidv4() // Générez un UUID
    const filename = uuid + '.jpg' // Nom du fichier avec UUID et extension

    // Créez un dossier s'il n'existe pas déjà
    if (!fs.existsSync('imgECGs')) {
      fs.mkdirSync('imgECGs')
    }

    // Déplacez le fichier téléchargé vers le dossier imgECGs avec le nom de fichier UUID
    await imageFile.move('imgECGs', {
      name: filename,
      overwrite: true, // Si le fichier existe déjà, remplacez-le
    })

    // Enregistrez l'UUID dans la base de données avec l'ID de l'ECG correspondant
    const ecgId = request.input('ecgId') // Supposons que l'ID de l'ECG est envoyé dans la requête
    await Ecg.query().where('id', ecgId).update({ filename: uuid })

    return response.status(200).send(filename)
  }
}
