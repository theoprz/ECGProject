import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'ecg_tag'

  async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id').primary()
      table.string('ecg_id', 36).references('id').inTable('ecgs').onDelete('CASCADE')
      table.integer('tag_id').unsigned().references('id').inTable('tags').onDelete('CASCADE')
      table.unique(['ecg_id', 'tag_id'])

      table.timestamp('created_at')
      table.timestamp('updated_at')
    })
  }

  async down() {
    this.schema.dropTable(this.tableName)
  }
}
