import { emit } from "process";
import "reflect-metadata";
import { createConnection, InsertResult } from "typeorm";
import { LeaderBoard } from "./entity/leaderboard";
import { EM } from "./entityManager";

// const allLeaderboard = await LeaderBoard.find();
// if (!allLeaderboard)
//     console.log("not leaderboard");
const express = require('express')
const app = express()
const port = 3000
let em = new EM();
app.get('/', (req, res) => {
    res.send(`
    Use the endpoint /scores to show all the scores.</br>
    Use the endpoint /add/:name/:score to add the scores
    `);
});
app.get('/scores', (req, res) => {
    if (em.isConnected)
        LeaderBoard.find().then(f => {
            res.json(f);
        });

    else
        em.manager.then((m) => res.json(LeaderBoard.find()))
            .catch(e => res.json(e));
});
function addScore(name: string, score: string): Promise<InsertResult> {
    let a = new LeaderBoard();
    a.player = name;
    a.score = score;
    return LeaderBoard.insert(a);
}
app.get('/add/:name/:score', (req, res) => {
    if (em.isConnected) {
        addScore(req.params.name, req.params.score).then(m => {
            LeaderBoard.find().then(f => {
                res.json(f);
            });
        })
            .catch(e => res.json(e));
    }
    else
        em.manager.then((m) => {
            addScore(req.params.name, req.params.score).then(m => {
                LeaderBoard.find().then(f => {
                    res.json(f);
                });
            })
                .catch(e => res.json(e));

        })
            .catch(e => res.json(e));
});
app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
});