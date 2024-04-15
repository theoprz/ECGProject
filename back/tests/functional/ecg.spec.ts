import { test } from '@japa/runner'

test.group('Ecg', () => {
  test('Count all', async ({ client }) => {
    const response = await client.get('/api/v1/ecg/count')

    response.assertStatus(200)
  })
})
