import unittest
from app import app

class FlaskAppTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.client = app.test_client()
        cls.client.testing = True

    def test_index_page(self):
        response = self.client.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'GFG Snake Game Updated', response.data)
    
    def test_static_files(self):
        response = self.client.get('/static/game.js')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'const canvas', response.data)
if __name__ == '__main__':
    unittest.main()
