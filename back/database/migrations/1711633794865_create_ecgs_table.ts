import { BaseSchema } from '@adonisjs/lucid/schema'

export default class extends BaseSchema {
  protected tableName = 'ecgs'

  async up() {
    this.schema.createTable(this.tableName, (table) => {
      table.string('id', 36).primary()
      table.string('filename', 128).notNullable()
      table.string('title', 256)
      table.text('contexte').notNullable()
      table.text('comment').notNullable()
      table.tinyint('age').nullable()
      table.tinyint('sexe').nullable()
      table.string('posted_by').notNullable().defaultTo('0')
      table.string('validated_by').notNullable().defaultTo('0')
      table.binary('created').notNullable()
      table.binary('validated').notNullable()
      table.float('pixels_cm').notNullable()
      table.float('speed').notNullable().defaultTo(25)
      table.float('gain').notNullable().defaultTo(10)
      table.integer('quality').notNullable()

      table.timestamp('created_at')
      table.timestamp('updated_at')
    })
  }

  async down() {
    this.schema.dropTable(this.tableName)
  }
}
