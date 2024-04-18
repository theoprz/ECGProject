import { BaseSeeder } from '@adonisjs/lucid/seeders'
import Symptom from '#models/symptom'

export default class extends BaseSeeder {
  async run() {
    // Write your database queries inside the run method
    await Symptom.createMany([
      {
        name: 'Douleur thoracique',
      },
      {
        name: 'Dyspnée',
      },
      {
        name: 'Palpitations',
      },
      {
        name: 'Syncope',
      },
    ])
  }
}
