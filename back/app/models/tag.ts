import { DateTime } from 'luxon'
import { BaseModel, column, manyToMany } from '@adonisjs/lucid/orm'
import Ecg from '#models/ecg'
import type { ManyToMany } from '@adonisjs/lucid/types/relations'

export default class Tag extends BaseModel {
  @column({ isPrimary: true })
  declare id: number

  @column()
  declare name: string

  @column()
  declare parentId: number | null

  @column()
  declare main: number

  @column()
  declare refTagId: number | null

  @column()
  declare weight: number

  @manyToMany(() => Ecg)
  declare ecgs: ManyToMany<typeof Ecg>

  @column.dateTime({ autoCreate: true })
  declare createdAt: DateTime

  @column.dateTime({ autoCreate: true, autoUpdate: true })
  declare updatedAt: DateTime
}
