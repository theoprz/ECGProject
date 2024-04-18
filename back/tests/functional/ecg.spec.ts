import { test } from '@japa/runner'

test.group('Ecg', () => {
  test('Count all', async ({ client }) => {
    const response = await client.get('/api/v1/ecg/info/count')

    response.assertStatus(200)
  })
})
