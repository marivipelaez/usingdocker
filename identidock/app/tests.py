# -*- coding: utf-8 -*-

u"""
(c) Copyright 2016 Telefónica I+D. Printed in Spain (Europe). All Rights
Reserved.

The copyright to the software program(s) is property of Telefónica I+D.
The program(s) may be used and or copied only with the express written
consent of Telefónica I+D or in accordance with the terms and conditions
stipulated in the agreement/contract under which the program(s) have
been supplied.
"""

import unittest
import identidock


class IdentidockTestCase(unittest.TestCase):

    def setUp(self):
        identidock.app.config["TESTING"] = True
        self.app = identidock.app.test_client()

    def test_get_mainpage(self):
        page = self.app.post("/", data=dict(name="Moby Dock"))
        assert page.status_code == 200
        assert 'Hello' in str(page.data)
        assert 'Moby Dock' in str(page.data)

    def test_html_escaping(self):
            page = self.app.post("/", data=dict(name='"><b>TEST</b><!--'))
            assert '<b>' not in str(page.data)


if __name__ == '__main__':
    unittest.main()
