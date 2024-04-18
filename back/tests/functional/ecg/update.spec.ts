import { test } from '@japa/runner'
import Ecg from '#models/ecg'
import { v4 as uuidv4 } from 'uuid'

test.group('Ecg update', () => {
  test('Update one', async ({ client }) => {
    const ecg = await Ecg.findByOrFail('title', 'Test ECG')
    const response = await client.put('/api/v1/ecg/' + ecg.id).json({
      title: 'updated_one',
      filename: 'updated_one',
      contexte: 'updated_one',
      comment: 'updated_one',
    })

    response.assertStatus(200)
    response.assertBodyContains({
      description: 'Ecg record updated',
      content: {
        filename: 'updated_one',
        title: 'updated_one',
        contexte: 'updated_one',
        comment: 'updated_one',
      },
    })
  })
    .setup(async () => {
      const ecg = await Ecg.create({
        id: uuidv4(),
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
      const ecg = await Ecg.findByOrFail('title', 'updated_one')
      if (ecg) await ecg.delete()
    })

  test('Update one not found', async ({ client }) => {
    const response = await client.put('/api/v1/ecg/update_one_not_found').json({
      title: 'updated_one',
      filename: 'updated_one',
      contexte: 'updated_one',
      comment: 'updated_one',
    })

    response.assertStatus(404)
    response.assertBodyContains({
      description: 'Ecg record not found',
      content: null,
    })
  })
})
