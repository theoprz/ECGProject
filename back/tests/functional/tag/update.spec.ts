import { test } from '@japa/runner'
import Tag from '#models/tag'

test.group('Tag update', () => {
  test('Update one', async ({ client }) => {
    const tag = await Tag.findByOrFail('name', 'Tag test')
    const response = await client.put('/api/v1/tag/' + tag.id).json({
      name: 'updated_one',
      main: 100,
      weight: 100,
    })

    response.assertStatus(200)
    response.assertBodyContains({
      description: 'Tag updated',
      content: {
        name: 'updated_one',
        main: 100,
        weight: 100,
      },
    })
  })
    .setup(async () => {
      await Tag.create({
        parentId: null,
        name: 'Tag test',
        main: 1,
        refTagId: null,
        weight: 1.5,
      })
    })
    .teardown(async () => {
      const tag = await Tag.findByOrFail('name', 'updated_one')
      if (tag) await tag.delete()
    })
})
