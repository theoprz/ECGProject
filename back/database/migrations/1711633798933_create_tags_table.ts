import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'tags'

  async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id').primary()
      table.string('name', 128).notNullable()
      table.integer('parent_id').nullable()
      table.smallint('main').notNullable().defaultTo(0)
      table.integer('ref_tag_id').nullable()
      table.float('weight').notNullable()

      table.timestamp('created_at')
      table.timestamp('updated_at')
    })
  }

  async down() {
    this.schema.dropTable(this.tableName)
  }
}
