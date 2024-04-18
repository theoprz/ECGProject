import { BaseSeeder } from '@adonisjs/lucid/seeders'

export default class IndexSeeders extends BaseSeeder {
  private async seed(Seeder: { default: typeof BaseSeeder }) {
    await new Seeder.default(this.client).run()
  }

  async run() {
    // Write your database queries inside the run method
    await this.seed(await import('../tag_seeder.js'))
    await this.seed(await import('../symptom_seeder.js'))
    await this.seed(await import('../ecg_seeder.js'))
  }
}
