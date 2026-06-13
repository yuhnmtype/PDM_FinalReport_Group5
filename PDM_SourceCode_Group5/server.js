require('dotenv').config();
const express = require('express');
const cors    = require('cors');
const path    = require('path');

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Routes
app.use('/api', require('./routes/auth'));
app.use('/api', require('./routes/elections'));
app.use('/api', require('./routes/votes'));
app.use('/api', require('./routes/admin'));

app.listen(3000, () => console.log('🚀 Server running at http://localhost:3000'));