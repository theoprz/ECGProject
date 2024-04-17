import type { HttpContext } from '@adonisjs/core/http'
import Ecg from '#models/ecg'
import * as fs from 'node:fs'
import path, { join } from 'node:path'
import * as url from 'node:url'
import * as PDFKit from 'pdfkit'
import blobStream from 'blob-stream'

export default class EcgsController {
  async index({ response }: HttpContext) {
    const ecgs = await Ecg.query().preload('tags')

    if (ecgs) {
      return response.status(200).json({ description: 'Ecg records found', content: ecgs })
    } else {
      return response.status(404).json({ description: 'No Ecg records found', content: null })
    }
  }

  async store({ request, response }: HttpContext) {
    if (
      'id' in request.body() &&
      'filename' in request.body() &&
      'title' in request.body() &&
      'contexte' in request.body() &&
      'comment' in request.body() &&
      'age' in request.body() &&
      'sexe' in request.body() &&
      'posted_by' in request.body() &&
      'validated_by' in request.body() &&
      'created' in request.body() &&
      'validated' in request.body() &&
      'pixels_cm' in request.body() &&
      'speed' in request.body() &&
      'gain' in request.body() &&
      'quality' in request.body()
    ) {
      const ecg = await Ecg.create(request.body())
      if (request.input('tags') !== undefined) {
        await ecg.related('tags').attach(request.input('tags'))
      }

      if (ecg) {
        const ecgToReturn = await Ecg.query().preload('tags').where('id', ecg.id).first()
        return response
          .status(201)
          .json({ description: 'Ecg record created', content: ecgToReturn })
      } else {
        console.log('Ecg record not created')
        return response.status(500).json({ description: 'Ecg record not created', content: null })
      }
    } else {
      console.log('Missing required fields')
      return response.status(406).json({ description: 'Missing required fields', content: null })
    }
  }
  async show({ params, response }: HttpContext) {
    const ecg = await Ecg.query().preload('tags').where('id', params.id).first()

    if (ecg) {
      return response.status(200).json({ description: 'Ecg record found', content: ecg })
    } else {
      return response.status(404).json({ description: 'Ecg record not found', content: null })
    }
  }

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

  async destroy({ params, response }: HttpContext) {
    const ecg = await Ecg.find(params.id)

    if (ecg) {
      await ecg.delete()
      return response.status(200).json({ description: 'Ecg record deleted', content: null })
    } else {
      return response.status(404).json({ description: 'Ecg record not found', content: null })
    }
  }

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

  async indexByUser({ params, response }: HttpContext) {
    const ecgs = await Ecg.query().preload('tags').where('posted_by', params.user)

    if (ecgs) {
      return response.status(200).json({ description: 'Ecg records found', content: ecgs })
    } else {
      return response.status(404).json({ description: 'No Ecg records found', content: null })
    }
  }

  async uploadPdf({ params, response }: HttpContext) {
    // Récupérer l'ID de l'ECG
    const ecgId = params.id
    console.log(ecgId)

    // Récupérer le chemin de l'image
    let imagePath = join(
      path.dirname(url.fileURLToPath(import.meta.url)),
      '..',
      '..',
      'public',
      'imgECGs',
      ecgId + '.jpg'
    )

    // Vérifier si le fichier image existe
    const imageExists = await fs.promises
      .access(imagePath, fs.constants.F_OK)
      .then(() => true)
      .catch(() => false)

    // Si l'image n'existe pas, utiliser une image par défaut
    if (!imageExists) {
      imagePath = join(
        path.dirname(url.fileURLToPath(import.meta.url)),
        '..',
        '..',
        'public',
        'imgECGs',
        'noimg.jpg'
      )
    }

    // Récupérer les données de l'ECG
    const ecg = await Ecg.query().preload('tags').where('id', ecgId).first()

    // Si l'ECG n'existe pas, retourner une erreur 404
    if (!ecg) {
      return response.status(404).send('ECG not found')
    }

    // Créer un nouveau document PDF
    const doc = new PDFKit.default()

    // Ajouter l'image de l'ECG à la première page
    doc.image(imagePath, {
      fit: [250, 250], // Taille de l'image dans le PDF
      align: 'center',
      valign: 'center',
    })

    // Définir le nom du fichier PDF
    const pdfPath = join(
      path.dirname(url.fileURLToPath(import.meta.url)),
      '..',
      '..',
      'public',
      'pdfs',
      ecgId + '.pdf'
    )

    // Pipe the PDF into a write stream to save it to the file system
    doc.pipe(fs.createWriteStream(pdfPath))

    const buffers: Buffer[] = []
    doc.on('data', buffers.push.bind(buffers))
    const thestream = doc.pipe(blobStream())

    // Ajouter une nouvelle page pour afficher les données de l'ECG
    doc.addPage()

    // Ajouter les données de l'ECG à la deuxième page
    doc.fontSize(12).text('ID: ' + ecg.id)
    doc.fontSize(12).text('Title: ' + ecg.title)
    doc.fontSize(12).text('Contexte: ' + ecg.contexte)
    doc.fontSize(12).text('Comment: ' + ecg.comment)
    doc.fontSize(12).text('Age: ' + ecg.age)
    doc.fontSize(12).text('Sexe: ' + ecg.sexe)
    doc.fontSize(12).text('Posted by: ' + ecg.postedBy)
    doc.fontSize(12).text('Validated by: ' + ecg.validatedBy)
    doc.fontSize(12).text('Created: ' + ecg.created)
    doc.fontSize(12).text('Validated: ' + ecg.validated)
    doc.fontSize(12).text('Pixels per cm: ' + ecg.pixelsCm)
    doc.fontSize(12).text('Speed: ' + ecg.speed)
    doc.fontSize(12).text('Gain: ' + ecg.gain)
    doc.fontSize(12).text('Quality: ' + ecg.quality)
    await doc.end()

    thestream.on('finish', () => {
      let pdfData = Buffer.concat(buffers)
      response.header('Content-type', 'application/pdf')
      response.header('Content-Length', pdfData.length)
      response.header('Content-disposition', `attachment; filename=t.pdf`)
      console.log(pdfData)
      response.send(pdfData)
    })
  }
}
