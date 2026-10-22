
import unittest
from unittest.mock import patch
from app import app


class FlaskAppTests(unittest.TestCase):

    def setUp(self):
        self.client = app.test_client()

    def test_health_endpoint(self):
        response = self.client.get("/health")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(
            response.get_json(),
            {"status": "healthy"}
        )

    @patch("app.r.incr", return_value=7)
    def test_api_endpoint(self, mock_incr):
        response = self.client.get("/api")

        self.assertEqual(response.status_code, 200)
        self.assertEqual(
            response.get_json(),
            {
                "message": "Hello from Asif's Docker DevOps Project",
                "visits": 7
            }
        )

        mock_incr.assert_called_once_with("visits")


if __name__ == "__main__":
    unittest.main()
