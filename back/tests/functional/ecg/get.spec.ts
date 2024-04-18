import { test } from '@japa/runner'
import Ecg from '#models/ecg'

test.group('Ecg get', () => {
  test('Get all', async ({ client }) => {
    const response = await client.get('/api/v1/ecg')

    response.assertStatus(200)
    response.assertBodyContains({ description: 'Ecg records found' })
  })

  test('Get one success', async ({ client }) => {
    const response = await client.get('/api/v1/ecg/ecg_id_for_testing')

    response.assertStatus(200)
    response.assertBodyContains({ description: 'Ecg record found' })
  })
    .setup(async () => {
      const ecg = await Ecg.create({
        id: 'ecg_id_for_testing',
        filename: 'Test filename',
        title: 'Test ECG',
        contexte: 'Test context',
        comment: 'Test comment',
        age: 18,
        sexe: 1,
        postedBy: 123456789123456780,
        validatedBy: 987654321987654300,
        created: Buffer.from([48]),
        validated: Buffer.from([48]),
        pixelsCm: 100,
        speed: 100,
        gain: 100,
        quality: 100,
      })
      await ecg.related('tags').attach([1, 2])
    })
    .teardown(async () => {
      await Ecg.query().where('id', 'ecg_id_for_testing').delete()
    })

  test('Get one not found', async ({ client }) => {
    const response = await client.get('/api/v1/ecg/ecg_id_for_testing_not_found')

    response.assertStatus(404)
    response.assertBody({ description: 'Ecg record not found', content: null })
  })
})
