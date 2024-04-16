import type { HttpContext } from '@adonisjs/core/http'
import Ecg from '#models/ecg'
import * as fs from 'node:fs'
import path, { join } from 'node:path'
import * as url from 'node:url'

export default class EcgsController {
  /**
   * Display a list of resource
   */
  async index({ response }: HttpContext) {
    const ecgs = await Ecg.query().preload('tags')

    if (ecgs) {
      return response.status(200).json({ description: 'Ecg records found', content: ecgs })
    } else {
      return response.status(404).json({ description: 'No Ecg records found', content: null })
    }
  }

  /**
   * Handle form submission for the create action
   */
  async store({ request, response }: HttpContext) {
    if (
      request.input('id') !== null &&
      request.input('id') !== undefined &&
      request.input('filename') !== null &&
      request.input('filename') !== undefined &&
      request.input('title') !== null &&
      request.input('title') !== undefined &&
      request.input('contexte') !== null &&
      request.input('contexte') !== undefined &&
      request.input('comment') !== null &&
      request.input('comment') !== undefined &&
      request.input('age') !== null &&
      request.input('age') !== undefined &&
      request.input('sexe') !== null &&
      request.input('sexe') !== undefined &&
      request.input('posted_by') !== null &&
      request.input('posted_by') !== undefined &&
      request.input('validated_by') !== null &&
      request.input('validated_by') !== undefined &&
      request.input('created') !== null &&
      request.input('created') !== undefined &&
      request.input('validated') !== null &&
      request.input('validated') !== undefined &&
      request.input('pixels_cm') !== null &&
      request.input('pixels_cm') !== undefined &&
      request.input('speed') !== null &&
      request.input('speed') !== undefined &&
      request.input('gain') !== null &&
      request.input('gain') !== undefined &&
      request.input('quality') !== null &&
      request.input('quality') !== undefined
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
        return response.status(500).json({ description: 'Ecg record not created', content: null })
      }
    } else {
      return response.status(406).json({ description: 'Missing required fields', content: null })
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
        return response.status(500).json({ description: 'Ecg record not updated', content: null })
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
  async count({ response }: HttpContext) {
    const ecgs = await Ecg.query()
    return response.status(200).json(ecgs.length)
  }

  async uploadFile({ request, response }: HttpContext) {
    const imageFile = request.file('image')

    if (!imageFile) {
      return response.status(400).send('No file uploaded')
    }

    const ecgId = request.input('ecgId')
    const filename = ecgId + '.jpg' // Nom du fichier avec UUID et extension

    // Créez un dossier s'il n'existe pas déjà
    if (!fs.existsSync('./public/imgECGs')) {
      fs.mkdirSync('./public/imgECGs')
    }

    // Déplacez le fichier téléchargé vers le dossier imgECGs avec le nom de fichier UUID
    await imageFile.move('./public/imgECGs', {
      name: filename,
      overwrite: true, // Si le fichier existe déjà, remplacez-le
    })

    // Enregistrez l'UUID dans la base de données avec l'ID de l'ECG correspondant
    //await Ecg.query().where('id', ecgId).update({ filename: ecgId })

    return response.status(200).send(filename)
  }

  async getImage({ request, response }: HttpContext) {
    const ecgId = request.input('ecgId')

    const imagePath = join(
      path.dirname(url.fileURLToPath(import.meta.url)),
      '..',
      '..',
      'public',
      'imgECGs',
      ecgId + '.jpg'
    )

    // Vérifier si le fichier existe
    const exists = await fs.promises
      .access(imagePath, fs.constants.F_OK)
      .then(() => true)
      .catch(() => false)

    if (!exists) {
      return response.status(404).send('Image not found')
    }

    // Retourne le chemin d'accès de l'image dans la réponse
    return response.download(imagePath)
  }
}
