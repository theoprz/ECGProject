import { test } from '@japa/runner'

test.group('Ecg get', () => {
  test('Get all', async ({ client }) => {
    const response = await client.get('/api/v1/ecg')

    response.assertStatus(200)
    response.assertBodyContains({ description: 'Ecg records found' })
  })

  test('Get one', async ({ client }) => {
    const response = await client.get('/api/v1/ecg/01901107-504b-4837-b39a-e9362678e7f7')

    response.assertStatus(200)
    response.assertBodyContains({ description: 'Ecg record found' })
  })
})
