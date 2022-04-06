import clearskies
from . import models
from .categories_api import categories_api
from .manufacturers_api import manufacturers_api
from .products_api import products_api

api = clearskies.Application(
    clearskies.handlers.SimpleRouting,
    {
        'authentication': clearskies.authentication.public(),
        'routes': [
            {
                'path': 'categories',
                'application': categories_api,
            },
            {
                'path': 'manufacturers',
                'application': manufacturers_api,
            },
            {
                'path': 'products',
                'application': products_api,
            },
        ],
        'schema_route': 'schema',
    },
)
