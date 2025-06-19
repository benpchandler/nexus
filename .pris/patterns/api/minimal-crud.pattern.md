---
pattern_id: "minimal-crud-endpoints"
name: "Minimal CRUD Endpoints"
language: "python"
framework: "flask"
type: "api"
tags: ["crud", "minimal", "flask", "learning", "simple"]
description: "Basic CRUD endpoint implementation without auth, pagination, or enterprise features"
usage_prompt: "When creating simple CRUD endpoints for learning or personal projects"
complexity_tier: "minimal"
appropriate_for: ["learning", "personal", "prototypes"]
avoid_for: ["production", "enterprise", "high-traffic"]
dependencies_count: 2
estimated_lines: 50
common_mistakes:
  - "Adding unnecessary complexity"
  - "Including enterprise features not requested"
  - "Over-engineering for simple use cases"
success_rate: 0.98
usage_count: 12
---

```python
from flask import Flask, request, jsonify
import sqlite3

app = Flask(__name__)

def init_db():
    conn = sqlite3.connect('data.db')
    conn.execute('CREATE TABLE IF NOT EXISTS items (id INTEGER PRIMARY KEY, name TEXT, description TEXT)')
    conn.close()

def get_db():
    return sqlite3.connect('data.db')

@app.route('/items', methods=['GET'])
def list_items():
    conn = get_db()
    items = conn.execute('SELECT id, name, description FROM items').fetchall()
    conn.close()
    return jsonify([{'id': row[0], 'name': row[1], 'description': row[2]} for row in items])

@app.route('/items', methods=['POST'])
def create_item():
    data = request.json
    conn = get_db()
    cursor = conn.execute('INSERT INTO items (name, description) VALUES (?, ?)', 
                         (data['name'], data.get('description', '')))
    conn.commit()
    item_id = cursor.lastrowid
    conn.close()
    return jsonify({'id': item_id, 'name': data['name'], 'description': data.get('description', '')}), 201

@app.route('/items/<int:item_id>', methods=['GET'])
def get_item(item_id):
    conn = get_db()
    item = conn.execute('SELECT id, name, description FROM items WHERE id = ?', (item_id,)).fetchone()
    conn.close()
    if item:
        return jsonify({'id': item[0], 'name': item[1], 'description': item[2]})
    return jsonify({'error': 'Item not found'}), 404

@app.route('/items/<int:item_id>', methods=['PUT'])
def update_item(item_id):
    data = request.json
    conn = get_db()
    conn.execute('UPDATE items SET name = ?, description = ? WHERE id = ?',
                (data['name'], data.get('description', ''), item_id))
    conn.commit()
    conn.close()
    return jsonify({'id': item_id, 'name': data['name'], 'description': data.get('description', '')})

@app.route('/items/<int:item_id>', methods=['DELETE'])
def delete_item(item_id):
    conn = get_db()
    conn.execute('DELETE FROM items WHERE id = ?', (item_id,))
    conn.commit()
    conn.close()
    return '', 204

if __name__ == '__main__':
    init_db()
    app.run(debug=True)
```

## Usage Notes

**Perfect for:**
- Learning REST API concepts
- Personal projects
- Quick prototypes
- Understanding CRUD operations

**When to upgrade:**
- Need user authentication → Use `auth-crud.pattern.md`
- Need pagination → Use `crud-endpoints.pattern.md`
- Production deployment → Add proper error handling and validation

**Test this pattern:**
```bash
curl -X POST http://localhost:5000/items -H "Content-Type: application/json" -d '{"name": "Test Item"}'
curl http://localhost:5000/items
```