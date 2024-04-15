import { test } from '@japa/runner'
import Ecg from '#models/ecg'

test.group('Ecg delete', () => {
  test('Delete one', async ({ client }) => {
    const ecg = await Ecg.findByOrFail('title', 'Test ECG')
    const response = await client.delete('/api/v1/ecg/' + ecg.id)

    response.assertStatus(200)
    response.assertBody({
      description: 'Ecg record deleted',
      content: null,
    })
  }).setup(async () => {
    const ecg = await Ecg.create({
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
})
