### **Exercise 3: Python Flask with Read-Only**

**`app.py`**
```python
from flask import Flask
import os
import tempfile
import logging

app = Flask(__name__)

# Configure logging to write to stdout (captured by Docker)
logging.basicConfig(level=logging.INFO)

@app.route('/')
def home():
    # Try to write to different locations
    results = {
        'readonly_status': {},
        'writable_locations': []
    }
    
    # Test locations
    test_paths = ['/tmp', '/var/log', '/data', '/app']
    
    for path in test_paths:
        try:
            test_file = os.path.join(path, 'test_write.txt')
            with open(test_file, 'w') as f:
                f.write('test')
            os.remove(test_file)
            results['writable_locations'].append(path)
            results['readonly_status'][path] = 'writable'
        except (IOError, OSError) as e:
            results['readonly_status'][path] = f'read-only: {str(e)}'
    
    return results

@app.route('/health')
def health():
    return {'status': 'healthy'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)