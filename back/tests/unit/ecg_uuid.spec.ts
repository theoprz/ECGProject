import { test } from '@japa/runner'
import Ecg from '#models/ecg'

test('UUID ecg creation', async ({ assert }) => {
  const ecg = await Ecg.create({
    filename: 'test_uuid_creation filename',
    title: 'test_uuid_creation title',
    contexte: 'test_uuid_creation context',
    comment: 'test_uuid_creation comment',
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

  await ecg.save()

  assert.exists(ecg.id)
}).teardown(async () => {
  await Ecg.query().where('filename', 'test_uuid_creation filename').delete()
})
