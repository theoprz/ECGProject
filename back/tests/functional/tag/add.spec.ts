import { test } from '@japa/runner'
import Tag from '#models/tag'

test.group('Tag add', () => {
  test('Create one', async ({ client }) => {
    const response = await client.post('/api/v1/tag').json({
      parent_id: null,
      name: 'new_one',
      main: 1,
      ref_tag_id: null,
      weight: 1.5,
    })

    response.assertStatus(201)
    response.assertBodyContains({
      description: 'Tag created',
      content: {
        parentId: null,
        name: 'new_one',
        main: 1,
        refTagId: null,
        weight: 1.5,
      },
    })
  }).teardown(async () => {
    await Tag.query().where('name', 'new_one').delete()
  })

  test('Create one missing required field', async ({ client }) => {
    const response = await client.post('/api/v1/tag')

    response.assertStatus(406)
    response.assertBodyContains({
      description: 'Missing required fields',
    })
  })
})
