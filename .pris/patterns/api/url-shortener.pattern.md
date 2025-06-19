---
pattern_id: "url-shortener-minimal"
name: "Minimal URL Shortener"
language: "python"
framework: "flask"
type: "api"
tags: ["url-shortener", "minimal", "flask", "personal", "simple"]
description: "Complete URL shortener in a single file - perfect for personal use"
usage_prompt: "When building a simple URL shortener for personal or learning purposes"
complexity_tier: "minimal"
appropriate_for: ["learning", "personal", "self-hosted"]
avoid_for: ["high-traffic", "enterprise", "commercial"]
dependencies_count: 1
estimated_lines: 60
common_mistakes:
  - "Adding complex analytics"
  - "Over-engineering the short code generation"
  - "Adding unnecessary user management"
success_rate: 0.99
usage_count: 5
---

```python
from flask import Flask, request, redirect, render_template_string, jsonify
import sqlite3
import string
import random
import os

app = Flask(__name__)

# Simple HTML template
HTML_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>URL Shortener</title>
    <style>
        body { font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; }
        input[type="url"] { width: 400px; padding: 10px; }
        button { padding: 10px 20px; background: #007bff; color: white; border: none; cursor: pointer; }
        .result { margin: 20px 0; padding: 10px; background: #f8f9fa; border-radius: 4px; }
        .stats { margin-top: 30px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
    </style>
</head>
<body>
    <h1>URL Shortener</h1>
    
    <form method="post" action="/shorten">
        <input type="url" name="url" placeholder="Enter URL to shorten" required>
        <button type="submit">Shorten</button>
    </form>
    
    {% if short_url %}
    <div class="result">
        <strong>Short URL:</strong> <a href="{{ short_url }}" target="_blank">{{ short_url }}</a>
        <br><small>Original: {{ original_url }}</small>
    </div>
    {% endif %}
    
    <div class="stats">
        <h3>Recent URLs</h3>
        <table>
            <tr><th>Short</th><th>Original</th><th>Clicks</th></tr>
            {% for url in recent_urls %}
            <tr>
                <td><a href="/{{ url.short }}">{{ url.short }}</a></td>
                <td>{{ url.original[:50] }}{% if url.original|length > 50 %}...{% endif %}</td>
                <td>{{ url.clicks }}</td>
            </tr>
            {% endfor %}
        </table>
    </div>
</body>
</html>
'''

def init_db():
    """Initialize SQLite database"""
    conn = sqlite3.connect('urls.db')
    conn.execute('''
        CREATE TABLE IF NOT EXISTS urls (
            short TEXT PRIMARY KEY,
            original TEXT NOT NULL,
            clicks INTEGER DEFAULT 0,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()

def generate_short_code():
    """Generate a random 6-character short code"""
    characters = string.ascii_letters + string.digits
    return ''.join(random.choices(characters, k=6))

def get_db():
    """Get database connection"""
    return sqlite3.connect('urls.db')

@app.route('/')
def home():
    """Home page with URL shortening form"""
    conn = get_db()
    recent_urls = conn.execute(
        'SELECT short, original, clicks FROM urls ORDER BY created_at DESC LIMIT 10'
    ).fetchall()
    conn.close()
    
    urls = [{'short': r[0], 'original': r[1], 'clicks': r[2]} for r in recent_urls]
    return render_template_string(HTML_TEMPLATE, recent_urls=urls)

@app.route('/shorten', methods=['POST'])
def shorten_url():
    """Create a short URL"""
    original_url = request.form['url']
    
    # Ensure URL has protocol
    if not original_url.startswith(('http://', 'https://')):
        original_url = 'https://' + original_url
    
    # Generate unique short code
    conn = get_db()
    while True:
        short_code = generate_short_code()
        existing = conn.execute('SELECT short FROM urls WHERE short = ?', (short_code,)).fetchone()
        if not existing:
            break
    
    # Save to database
    conn.execute('INSERT INTO urls (short, original) VALUES (?, ?)', (short_code, original_url))
    conn.commit()
    
    # Get recent URLs for display
    recent_urls = conn.execute(
        'SELECT short, original, clicks FROM urls ORDER BY created_at DESC LIMIT 10'
    ).fetchall()
    conn.close()
    
    short_url = request.host_url + short_code
    urls = [{'short': r[0], 'original': r[1], 'clicks': r[2]} for r in recent_urls]
    
    return render_template_string(
        HTML_TEMPLATE,
        short_url=short_url,
        original_url=original_url,
        recent_urls=urls
    )

@app.route('/<short_code>')
def redirect_url(short_code):
    """Redirect to original URL and track clicks"""
    conn = get_db()
    
    # Get original URL and increment click count
    result = conn.execute('SELECT original FROM urls WHERE short = ?', (short_code,)).fetchone()
    
    if result:
        original_url = result[0]
        conn.execute('UPDATE urls SET clicks = clicks + 1 WHERE short = ?', (short_code,))
        conn.commit()
        conn.close()
        return redirect(original_url)
    else:
        conn.close()
        return f'Short URL "{short_code}" not found', 404

@app.route('/api/stats/<short_code>')
def get_stats(short_code):
    """Get statistics for a short URL"""
    conn = get_db()
    result = conn.execute(
        'SELECT original, clicks, created_at FROM urls WHERE short = ?',
        (short_code,)
    ).fetchone()
    conn.close()
    
    if result:
        return jsonify({
            'short_code': short_code,
            'original_url': result[0],
            'clicks': result[1],
            'created_at': result[2]
        })
    else:
        return jsonify({'error': 'Short URL not found'}), 404

if __name__ == '__main__':
    init_db()
    app.run(debug=True, host='0.0.0.0', port=5000)
```

## Usage Instructions

1. **Install Flask**: `pip install flask`
2. **Run the app**: `python app.py`
3. **Open browser**: Go to `http://localhost:5000`
4. **Shorten URLs**: Enter any URL and get a short version
5. **View stats**: See click counts and recent URLs

## Features

- ✅ URL shortening with random codes
- ✅ Click tracking
- ✅ Web interface
- ✅ Recent URLs display
- ✅ Simple statistics
- ✅ Single file deployment
- ✅ SQLite database (no setup required)

## Perfect for

- Personal use
- Learning web development
- Self-hosted solutions
- Quick prototypes

## To enhance later

- Custom short codes
- Expiration dates
- User accounts
- Analytics dashboard