import clearskies
from .models import Manufacturer

manufacturers_api = clearskies.Application(
    clearskies.handlers.RestfulAPI,
    {
        'model_class': Manufacturer,
        'readable_columns': ['name', 'description', 'created_at', 'updated_at'],
        'writeable_columns': ['name', 'description'],
        'searchable_columns': ['name', 'description'],
        'default_sort_column': 'name',
    },
    binding_classes=[Manufacturer],
)
