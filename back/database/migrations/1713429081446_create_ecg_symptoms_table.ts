import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'ecg_symptom'

  async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.increments('id').primary()
      table.string('ecg_id', 36).references('id').inTable('ecgs').onDelete('CASCADE')
      table.integer('symptom_id').unsigned().references('id').inTable('symptoms').onDelete('CASCADE')
      table.unique(['ecg_id', 'symptom_id'])

      table.timestamp('created_at')
      table.timestamp('updated_at')
    })
  }

  async down() {
    this.schema.dropTable(this.tableName)
  }
}
