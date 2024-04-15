import { test } from '@japa/runner'

test.group('Tag get', () => {
  test('Get all', async ({ client }) => {
    const response = await client.get('/api/v1/tag')

    response.assertStatus(200)
    response.assertBodyContains({
      description: 'Tags found',
    })
  })

  test('Get one success', async ({ client }) => {
    const response = await client.get('/api/v1/tag/1')

    response.assertStatus(200)
    response.assertBodyContains({
      description: 'Tag found',
      content: {
        id: 1,
        name: 'Autre',
        parentId: null,
        main: 1,
        refTagId: null,
        weight: 1.5,
      },
    })
  })

  test('Get one not found', async ({ client }) => {
    const response = await client.get('/api/v1/tag/tag_id_for_testing_not_found')

    response.assertStatus(404)
    response.assertBodyContains({
      description: 'Tag not found',
    })
  })
})
