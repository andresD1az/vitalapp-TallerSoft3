
const router = require('express').Router();

router.get('/', (_req, res) => {
  res.status(200).json({ status: 'healthy' });
});

module.exports = router;
