import { test } from '@japa/runner'
import Ecg from '#models/ecg'

test.group('Ecg add', () => {
  test('Create one success', async ({ client }) => {
    const response = await client.post('/api/v1/ecg').json({
      title: 'new_one',
      filename: 'new_one',
      contexte: 'new_one',
      comment: 'new_one',
      age: '18',
      sexe: '1',
      posted_by: '123456789123456789',
      validated_by: '987654321987654321',
      created: '0',
      validated: '0',
      pixels_cm: '100',
      speed: '100',
      gain: '100',
      quality: '100',
      tags: [1, 2],
    })

    response.assertStatus(201)
    response.assertBodyContains({
      description: 'Ecg record created',
      content: {
        filename: 'new_one',
        title: 'new_one',
        contexte: 'new_one',
        comment: 'new_one',
        age: 18,
        sexe: 1,
        postedBy: 123456789123456780,
        validatedBy: 987654321987654300,
        created: { type: 'Buffer', data: [48] },
        validated: { type: 'Buffer', data: [48] },
        pixelsCm: 100,
        speed: 100,
        gain: 100,
        quality: 100,
        tags: [
          {
            id: 1,
            name: 'Autre',
            parentId: null,
            main: 1,
            refTagId: null,
            weight: 1.5,
          },
          {
            id: 2,
            name: 'Aberration de conduction',
            parentId: 1,
            main: 1,
            refTagId: null,
            weight: 1.5,
          },
        ],
      },
    })
  }).teardown(async () => {
    await Ecg.query().where('title', 'new_one').delete()
  })

  test('Create one missing required field', async ({ client }) => {
    const response = await client.post('/api/v1/ecg')

    response.assertStatus(400)
    response.assertBody({
      description: 'Missing required fields',
      content: null,
    })
  })
})
