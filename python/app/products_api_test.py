import unittest
from clearskies.contexts import test
from unittest.mock import MagicMock
from types import SimpleNamespace
from .products_api import products_api
from collections import OrderedDict


class ProductsApiTest(unittest.TestCase):
    def setUp(self):
        self.api = test(products_api)

        self.categories = self.api.build('category')
        self.categories.create({
            'name': 'cat 1',
            'description': 'A cat',
        })
        self.cat_1 = self.categories.where('name=cat 1').first()
        self.categories.create({
            'name': 'cat 2',
            'description': 'Another cat',
        })
        self.cat_2 = self.categories.where('name=cat 2').first()

        self.manufacturers = self.api.build('manufacturer')
        self.manufacturers.create({
            'name': 'sup',
            'description': 'hey',
        })
        self.default_manufacturer = self.manufacturers.first()

        self.products = self.api.build('product')
        self.products.create({
            'manufacturer_id': self.default_manufacturer.id,
            'manufacturer_part_number': 'ASDF',
            'name': 'cool product',
            'description': 'very cool',
            'cost': 5.50,
            'price': 10.00,
            'categories': [self.cat_1.id, self.cat_2.id],
        })
        self.default_product = self.products.first()


    def test_list_all(self):
        result = self.api()
        self.assertEquals(200, result[1])
        response = result[0]
        self.assertEquals(1, len(response['data']))

        # It's the context that would convert the response to JSON, but the test context doesn't do that.
        # as a result, we get back the raw response as an OrderedDict
        self.assertEquals(OrderedDict([
            ('id', self.default_product.id),
            ('manufacturer_id', self.default_manufacturer.id),
            ('name', 'cool product'),
            ('short_description', None),
            ('manufacturer_part_number', 'ASDF'),
            ('description', 'very cool'),
            ('price', 10.00),
            ('categories', [{'id': self.cat_1.id, 'name': 'cat 1'}, {'id': self.cat_2.id, 'name': 'cat 2'}]),
            ('created_at', self.api.now.isoformat()),
            ('updated_at', self.api.now.isoformat()),
        ]), response['data'][0])
        self.assertEquals({'number_results': 1, 'limit': 100, 'next_page': {}}, response['pagination'])
        self.assertEquals('success', response['status'])

    def test_update(self):
        result = self.api(
            method='PUT',
            url=self.default_product.id,
            body={
                'manufacturer_id': self.default_manufacturer.id,
                'manufacturer_part_number': 'ASDFER',
                'name': 'a cool product',
                'short_description': 'hey',
                'description': 'VERY cool',
                'price': 10.50,
                'categories': [self.cat_2.id],
            }
        )
        self.assertEquals(200, result[1])
        response = result[0]

        self.assertEquals(OrderedDict([
            ('id', self.default_product.id),
            ('manufacturer_id', self.default_manufacturer.id),
            ('name', 'a cool product'),
            ('short_description', 'hey'),
            ('manufacturer_part_number', 'ASDFER'),
            ('description', 'VERY cool'),
            ('price', 10.50),
            ('categories', [{'id': self.cat_2.id, 'name': 'cat 2'}]),
            ('created_at', self.api.now.isoformat()),
            ('updated_at', self.api.now.isoformat()),
        ]), response['data'])
        self.assertEquals('success', response['status'])
