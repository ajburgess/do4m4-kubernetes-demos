const express = require('express')
const morgan = require('morgan')

const app = express()
app.use(morgan('combined'))

app.get('/', (req, res) => {
    res.send("\nHi there from version 1.0.2\n\n")
})

app.get('/info', (req, res) => {
    // Display info about the target and the (secret) launch code
    res.send(`\nTarget: ${process.env.TARGET}\nLaunch code: ${process.env.LAUNCH_CODE}\n\n`)
})

app.get('/oops', (req, res) => {
    // Simulate a crashing process
    process.exit(1);
})

const PORT = process.env.PORT || 8000
app.listen(PORT, function () {
    console.log(`Listening on port ${PORT}`)
})