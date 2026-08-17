'use strict';

const express = require('express');

const app = express();
app.use(express.json());

app.get('/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.get('/api/items', (_req, res) => {
  res.json({ items: ['item-1', 'item-2', 'item-3'] });
});

app.post('/api/items', (req, res) => {
  const { name } = req.body;
  if (!name || typeof name !== 'string') {
    return res.status(400).json({ error: 'name is required and must be a string' });
  }
  res.status(201).json({ id: Date.now(), name });
});

app.use((_req, res) => {
  res.status(404).json({ error: 'not found' });
});

module.exports = app;
