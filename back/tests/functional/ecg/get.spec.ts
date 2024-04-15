import { test } from '@japa/runner'

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

  test('Get one not found', async ({ client }) => {
    const response = await client.get('/api/v1/ecg/ecg_id_for_testing_not_found')

    response.assertStatus(404)
    response.assertBody({ description: 'Ecg record not found', content: null })
  })
})
