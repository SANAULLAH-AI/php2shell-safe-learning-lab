import tempfile
import unittest
from pathlib import Path
from detections.hunt_web_logs import PATTERNS

class DetectionPatternTests(unittest.TestCase):
    def test_multipart_request_matches(self):
        line = '203.0.113.10 - - "POST /upload HTTP/1.1" 500 multipart/form-data'
        self.assertTrue(any(label == "multipart POST" and pattern.search(line)
                            for label, pattern in PATTERNS))

    def test_normal_get_not_multipart(self):
        line = '203.0.113.10 - - "GET / HTTP/1.1" 200 text/html'
        self.assertFalse(any(label == "multipart POST" and pattern.search(line)
                             for label, pattern in PATTERNS))

if __name__ == "__main__":
    unittest.main()
