import { test } from '@japa/runner'

test.group('Tag get', () => {
  test('Get all', async ({ client }) => {
    const response = await client.get('/api/v1/tag')

    response.assertStatus(200)
    response.assertBodyContains({
      description: 'Tags found',
    })
  })

  test('Get one', async ({ client }) => {
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
})
