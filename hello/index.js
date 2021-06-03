const express = require('express')
const morgan = require('morgan')

const app = express()
app.use(morgan('combined'))

app.get('/', (req, res) => {
    res.send("\nHi there from version 1.0.0\n\n")
})

const PORT = process.env.PORT || 8000
app.listen(PORT, function () {
    console.log(`Listening on port ${PORT}`)
})