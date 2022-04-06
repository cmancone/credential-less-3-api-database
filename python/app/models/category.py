from collections import OrderedDict
from clearskies import Model
from clearskies import column_types
from clearskies.input_requirements import required, maximum_length
from . import product_category, product


class Category(Model):
    def __init__(self, cursor_backend, columns):
        super().__init__(cursor_backend, columns)

    def columns_configuration(self):
        return OrderedDict([
            column_types.belongs_to('parent_id', parent_models_class=Category),
            column_types.string('name', input_requirements=[required(), maximum_length(255)]),
            column_types.string('description', input_requirements=[required(), maximum_length(1024)]),
            column_types.updated('updated_at'),
            column_types.created('created_at'),
            column_types.many_to_many('products', pivot_models_class=product_category.ProductCategory, related_models_class=product.Product),
            column_types.has_many('sub_categories', child_models_class=Category, foreign_column_name='parent_id'),
        ])
