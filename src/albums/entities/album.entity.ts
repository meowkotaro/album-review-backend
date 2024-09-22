import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
} from 'typeorm'

@Entity()
export class Album {
  @PrimaryGeneratedColumn()
  id: number

  @Column()
  title: string

  @Column()
  artist: string

  @Column()
  releaseDate: Date

  @Column()
  genre: string

  @Column()
  coverImageUrl: string
}
