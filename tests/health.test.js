const request = require('supertest');
const app = require('../src/app');

describe('Health endpoint', () => {
  it('GET /health -> 200 healthy', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
    expect(res.body.status).toBe('healthy');
  });
});
