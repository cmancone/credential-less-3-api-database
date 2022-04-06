import unittest
from clearskies.contexts import test
from unittest.mock import MagicMock
from types import SimpleNamespace
from .manufacturers_api import manufacturers_api
from collections import OrderedDict


class ManufacturersApiTest(unittest.TestCase):
    def setUp(self):
        self.api = test(manufacturers_api)

        self.manufacturers = self.api.build('manufacturer')
        self.manufacturers.create({
            'name': 'sup',
            'description': 'hey',
        })

        self.default_manufacturer = self.manufacturers.where('name=sup').first()

    def test_list_all(self):
        result = self.api()
        self.assertEquals(200, result[1])
        response = result[0]
        self.assertEquals(1, len(response['data']))

        # It's the context that would convert the response to JSON, but the test context doesn't do that.
        # as a result, we get back the raw response as an OrderedDict
        self.assertEquals(OrderedDict([
            ('id', self.default_manufacturer.id),
            ('name', 'sup'),
            ('description', 'hey'),
            ('created_at', self.api.now.isoformat()),
            ('updated_at', self.api.now.isoformat()),
        ]), response['data'][0])
        self.assertEquals({'number_results': 1, 'limit': 100, 'next_page': {}}, response['pagination'])
        self.assertEquals('success', response['status'])

    def test_create(self):
        result = self.api(
            method='POST',
            body={
                'name': 'Hammers r us',
                'description': 'I like hammers',
            }
        )
        self.assertEquals(200, result[1])
        hammers = self.manufacturers.where('name=Hammers r us').first()
        self.assertTrue(hammers.exists)

        self.assertEquals(OrderedDict([
            ('id', hammers.id),
            ('name', 'Hammers r us'),
            ('description', 'I like hammers'),
            ('created_at', self.api.now.isoformat()),
            ('updated_at', self.api.now.isoformat()),
        ]), result[0]['data'])
