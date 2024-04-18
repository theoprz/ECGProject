import { BaseModel, column, manyToMany } from '@adonisjs/lucid/orm'
import Tag from '#models/tag'
import type { ManyToMany } from '@adonisjs/lucid/types/relations'
import Symptom from "#models/symptom";

export default class Ecg extends BaseModel {
  @column({ isPrimary: true })
  declare id: string

  @column()
  declare filename: string

  @column()
  declare title: string

  @column()
  declare contexte: string

  @column()
  declare comment: string

  @column()
  declare age: number | null

  @column()
  declare sexe: number | null

  @column()
  declare postedBy: number

  @column()
  declare validatedBy: number

  @column()
  declare created: Buffer

  @column()
  declare validated: Buffer

  @column()
  declare pixelsCm: number

  @column()
  declare speed: number

  @column()
  declare gain: number

  @column()
  declare quality: number

  @manyToMany(() => Symptom)
  declare symptoms: ManyToMany<typeof Symptom>

  @manyToMany(() => Tag)
  declare tags: ManyToMany<typeof Tag>
}
