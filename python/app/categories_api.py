import clearskies
from . import models

categories_api = clearskies.Application(
    clearskies.handlers.RestfulAPI,
    {
        'model_class': models.Category,
        'readable_columns': ['parent_id', 'name', 'description', 'created_at', 'updated_at'],
        'writeable_columns': ['parent_id', 'name', 'description'],
        'searchable_columns': ['parent_id', 'name', 'description'],
        'default_sort_column': 'name',
    },
    binding_modules=[models],
)
