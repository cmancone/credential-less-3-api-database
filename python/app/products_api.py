import clearskies
from . import models

products_api = clearskies.Application(
    clearskies.handlers.RestfulAPI,
    {
        'model_class': models.Product,
        'readable_columns': ['manufacturer_id', 'name', 'manufacturer_part_number', 'description', 'price', 'categories', 'created_at', 'updated_at'],
        'writeable_columns': ['manufacturer_id', 'name', 'manufacturer_part_number', 'description', 'price', 'categories'],
        'searchable_columns': ['manufacturer_id', 'name', 'manufacturer_part_number', 'description'],
        'default_sort_column': 'name',
    },
    binding_modules=[models],
)
