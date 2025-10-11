const app = require('./app');

const port = process.env.PORT || 3000;
const server = app.listen(port, () => console.log(`VitalApp escuchando en :${port}`));

module.exports = server;
