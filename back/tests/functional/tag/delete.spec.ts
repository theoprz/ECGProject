import { test } from '@japa/runner'
import Tag from '#models/tag'

test.group('Tag delete', () => {
  test('Delete one', async ({ client }) => {
    const tag = await Tag.findByOrFail('name', 'Tag test')
    const response = await client.delete('/api/v1/tag/' + tag.id)

    response.assertStatus(200)
    response.assertBody({
      description: 'Tag deleted',
      content: null,
    })
  }).setup(async () => {
    await Tag.create({
      parentId: null,
      name: 'Tag test',
      main: 1,
      refTagId: null,
      weight: 1.5,
    })
  })

  test('Delete one not found', async ({ client }) => {
    const response = await client.delete('/api/v1/tag/delete_one_not_found')

    response.assertStatus(404)
    response.assertBody({
      description: 'Tag not found',
      content: null,
    })
  })
})
