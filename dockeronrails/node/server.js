const express = require('express');
const app = express();
const PORT = 3001; // Or whatever port you want

app.get('/', (req, res) => {
  res.send('Node server is running!');
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Node server listening on port ${PORT}`);
});
