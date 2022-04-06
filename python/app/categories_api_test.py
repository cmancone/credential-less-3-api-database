import unittest
from clearskies.contexts import test
from unittest.mock import MagicMock
from types import SimpleNamespace
from .categories_api import categories_api
from collections import OrderedDict


class CategoriesApiTest(unittest.TestCase):
    def setUp(self):
        self.api = test(categories_api)

        self.categories = self.api.build('category')
        self.categories.create({
            'name': 'cat 1',
            'description': 'A cat',
        })
        self.cat_1 = self.categories.where('name=cat 1').first()
        self.categories.create({
            'parent_id': self.cat_1.id,
            'name': 'cat 2',
            'description': 'Another cat',
        })
        self.cat_2 = self.categories.where('name=cat 2').first()


    def test_list_all(self):
        result = self.api()
        self.assertEquals(200, result[1])
        response = result[0]
        self.assertEquals(2, len(response['data']))

        # It's the context that would convert the response to JSON, but the test context doesn't do that.
        # as a result, we get back the raw response as an OrderedDict
        self.assertEquals(OrderedDict([
            ('id', self.cat_1.id),
            ('parent_id', None),
            ('name', 'cat 1'),
            ('description', 'A cat'),
            ('created_at', self.api.now.isoformat()),
            ('updated_at', self.api.now.isoformat()),
        ]), response['data'][0])
        self.assertEquals(OrderedDict([
            ('id', self.cat_2.id),
            ('parent_id', self.cat_1.id),
            ('name', 'cat 2'),
            ('description', 'Another cat'),
            ('created_at', self.api.now.isoformat()),
            ('updated_at', self.api.now.isoformat()),
        ]), response['data'][1])
        self.assertEquals({'number_results': 2, 'limit': 100, 'next_page': {}}, response['pagination'])
        self.assertEquals('success', response['status'])
