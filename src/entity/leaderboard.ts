import { BaseEntity, Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class LeaderBoard extends BaseEntity {
    @PrimaryGeneratedColumn()
    id: number;
    @Column()
    player: string;
    @Column()
    score: string;
}