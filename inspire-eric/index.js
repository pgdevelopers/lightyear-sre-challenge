const express = require('express')

const app = express();
const port = 3030;

// Eric quotes
const quotes = [
  "sup boi",
  "not worth it",
  "god bls"
]

app.get('/api/eric', (req, res) => {
  let quote = quotes[Math.floor(Math.random() * quotes.length)];
  res.json({
    quote: quote
  })
});

app.listen(port, () => console.log(`Hello world app listening on port ${port}!`));