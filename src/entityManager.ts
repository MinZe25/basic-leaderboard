import { ConnectionOptions } from "tls";
import { Connection, createConnection, EntityManager } from "typeorm";

export class EM {
    private _manager: EntityManager = null;
    private _em;
    public get isConnected(): boolean {
        return this._manager != null;
    }
    public get manager(): Promise<EntityManager> {
        return new Promise<EntityManager>((resolve, reject) => {
            if (this._manager) {
                resolve(this._manager);
                return;
            }
            this.getConnection().then(c => {
                this._manager = c.manager;
                resolve(this._manager);
            }).catch(e => reject(e));
        });
    }

    private getConnection(): Promise<Connection> {
        return new Promise<Connection>((res, rej) => {
            createConnection().then(c => {
                res(c);
            }).catch(e => rej(e));
        });
    }

}